# ------------------------------------------------------------------
# VPC module – expose IDs for downstream modules
# ------------------------------------------------------------------

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.roboshop.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.private : s.id]
}

# Output the node security group ID (already defined earlier in the file)
output "node_sg_id" {
  description = "Security group attached to EKS worker nodes"
  value       = aws_security_group.node_sg.id
}

output "alb_sg_id" {
  description = "Security group attached to ALB"
  value       = aws_security_group.alb_sg.id
}
