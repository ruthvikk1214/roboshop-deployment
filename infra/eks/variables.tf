# ------------------------------------------------------------------
# Variables for the EKS wrapper module
# ------------------------------------------------------------------

variable "vpc_id" {
  description = "ID of the VPC created in infra/vpc"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs (for ALB ingress controller)"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs (where worker nodes live)"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ALB security group ID to allow inbound traffic from"
  type        = string
}
