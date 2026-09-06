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

# New variable – attach the custom node security group
variable "node_security_group_ids" {
  description = "Security group IDs to attach to the worker nodes (e.g., the node SG defined in the VPC module)"
  type        = list(string)
  default     = []
}
