# ------------------------------------------------------------------
# Route53 – A record for the Roboshop app
# ------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket = "roboshop-terraform-state-rk1214-9988"
    key    = "route53/terraform.tfstate"
    region = "us-east-1"
  }
}

variable "hosted_zone_id" {
  description = "ID of the existing Route53 hosted zone for rk1214.in"
  type        = string
  # No default – you must provide it via a .tfvars file or CLI flag.
}

# The ALB created by the aws-load-balancer-controller (Ingress) will have a name like "roboshop-alb"
# Adjust the name if you changed the Ingress metadata.name.

data "aws_lb" "roboshop_alb" {
  name = "roboshop-alb"
}

resource "aws_route53_record" "roboshop_a" {
  zone_id = var.hosted_zone_id
  name    = "roboshop.rk1214.in"
  type    = "A"

  alias {
    name                   = data.aws_lb.roboshop_alb.dns_name
    zone_id                = data.aws_lb.roboshop_alb.zone_id
    evaluate_target_health = false
  }
}

# Optional output so other modules/scripts can reference the DNS name
output "roboshop_alb_dns" {
  description = "The DNS name of the ALB serving roboshop"
  value       = data.aws_lb.roboshop_alb.dns_name
}
