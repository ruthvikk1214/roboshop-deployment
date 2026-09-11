# ------------------------------------------------------------------
# Route53 - A record for the Roboshop app
# ------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket = "roboshop-terraform-state-rk1214-9988"
    key    = "route53/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "hosted_zone_id" {
  description = "ID of the existing Route53 hosted zone for rk1214.in"
  type        = string
  default     = "Z031906510N5GWM6MW07L"
}

variable "alb_dns_name" {
  description = "DNS name of the ALB (from aws elbv2 describe-load-balancers)"
  type        = string
}

variable "alb_zone_id" {
  description = "Canonical hosted zone ID of the ALB"
  type        = string
}

resource "aws_route53_record" "roboshop_a" {
  zone_id = var.hosted_zone_id
  name    = "roboshop.rk1214.in"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}

output "roboshop_alb_dns" {
  description = "The DNS name of the ALB serving roboshop"
  value       = var.alb_dns_name
}
