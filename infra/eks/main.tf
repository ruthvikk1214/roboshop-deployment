# ------------------------------------------------------------------
# Terraform configuration & provider
# ------------------------------------------------------------------
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
# Data source - get VPC details to allow internal traffic
# ------------------------------------------------------------------
data "aws_vpc" "eks_vpc" {
  id = var.vpc_id
}

# ------------------------------------------------------------------
# Authenticate Terraform to the EKS Cluster
# ------------------------------------------------------------------
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# ------------------------------------------------------------------
# EKS Cluster – using the official Terraform AWS EKS module
# ------------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "roboshop-eks"
  cluster_version = "1.30"

  # Attach the VPC we created
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids # **private** subnets only

  # Enable OIDC so the Helm chart can create an IRSA ServiceAccount
  enable_irsa = true

  # Allow GitHub Actions runner to connect to the cluster API
  cluster_endpoint_public_access = true

  # -------------------------------------------------------------
  # Node Security Group Rules
  # -------------------------------------------------------------
  node_security_group_additional_rules = {
    ingress_vpc = {
      description = "Allow all traffic from VPC (fixes ALB 504 timeout)"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = [data.aws_vpc.eks_vpc.cidr_block]
    }
  }

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  # -------------------------------------------------------------
  # Node group – 3 Spot instances with root EBS on AL2023
  # -------------------------------------------------------------
  eks_managed_node_groups = {
    spot = {
      desired_size   = 2
      max_size       = 2
      min_size       = 1
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
      subnet_ids     = var.private_subnet_ids # can land in any of the AZs
      
      # Explicitly use Amazon Linux 2023 AMI required for Kubernetes 1.30
      ami_type = "AL2023_x86_64_STANDARD"
      # AL2023 uses standard cloud-init nodeadm rather than legacy AL2 bootstrap.sh
      enable_bootstrap_user_data = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 20 # GiB – smallest allowed for EBS
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

# ------------------------------------------------------------------
# GP3 Storage Class
# ------------------------------------------------------------------
resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }
  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
  parameters = {
    type = "gp3"
  }
  depends_on = [module.eks]
}