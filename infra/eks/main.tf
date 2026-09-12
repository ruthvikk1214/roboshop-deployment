# ------------------------------------------------------------------
# Terraform configuration & provider
terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# ------------------------------------------------------------------
# Data source – current region (used for the EKS module)
# ------------------------------------------------------------------
data "aws_region" "current" {}

# ------------------------------------------------------------------


# ------------------------------------------------------------------
# EKS Cluster – using the official Terraform AWS EKS module
# ------------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "roboshop-eks"
  cluster_version = "1.30" # latest stable at time of writing

  # Attach the VPC we created
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids # **private** subnets only

  # Enable OIDC so the Helm chart can create an IRSA ServiceAccount
  enable_irsa = true

  # Allow GitHub Actions runner to connect to the cluster API
  cluster_endpoint_public_access = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  # -------------------------------------------------------------
  # Node group – scaling to 2 instances to bypass IP limits
  # -------------------------------------------------------------
  eks_managed_node_groups = {
    spot = {
      desired_size           = 2
      max_size               = 2
      min_size               = 1
      instance_types         = ["t3.medium"]
      capacity_type          = "SPOT"
      subnet_ids             = var.private_subnet_ids # can land in any of the AZs
      ami_type               = "AL2_x86_64"
      # Optional: set a small root volume to keep costs down
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 8 # GiB – smallest allowed for EBS
            volume_type = "gp3"
          }
        }
      }
    }
  }

  tags = {
    Environment = "educational"
    Owner       = "ruthvikk1214"
  }
}

# ------------------------------------------------------------------
# Allow traffic from ALB Security Group to EKS Node Security Group
# ------------------------------------------------------------------
resource "aws_security_group_rule" "alb_to_nodes" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = var.alb_sg_id
  security_group_id        = module.eks.node_security_group_id
  description              = "Allow traffic from ALB"
}

# ------------------------------------------------------------------
# IAM Role for EBS CSI Driver (allows PVCs to provision EBS volumes)
# ------------------------------------------------------------------
module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name             = "${module.eks.cluster_name}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

# ------------------------------------------------------------------
# IAM Role for AWS Load Balancer Controller (IRSA)
# ------------------------------------------------------------------
module "alb_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                              = "${module.eks.cluster_name}-alb-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:alb-controller-sa"]
    }
  }
}
