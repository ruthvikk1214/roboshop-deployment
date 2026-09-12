# ------------------------------------------------------------------
# Root Terraform configuration – orchestrates VPC, EKS, and Route53 modules
# ------------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket = "roboshop-terraform-state-rk1214-9988"
    key    = "infra/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------------------
# Input variables
# ------------------------------------------------------------------
variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID for rk1214.in"
  type        = string
}

# ------------------------------------------------------------------
# VPC module
# ------------------------------------------------------------------
module "vpc" {
  source = "./vpc"
}

# ------------------------------------------------------------------
# EKS module – receives VPC outputs and node security group
# ------------------------------------------------------------------
module "eks" {
  source = "./eks"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  alb_sg_id          = module.vpc.alb_sg_id
}

# ------------------------------------------------------------------
# Outputs – expose useful values for downstream scripts
# ------------------------------------------------------------------
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_controller_role_arn" {
  description = "IAM Role ARN for the AWS Load Balancer Controller"
  value       = module.eks.alb_controller_role_arn
}

output "alb_sg_id" {
  description = "ALB Security Group ID"
  value       = module.vpc.alb_sg_id
}
