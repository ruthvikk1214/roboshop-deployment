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

output "alb_sg_id" {
  description = "Security group attached to ALB"
  value       = aws_security_group.alb_sg.id
}
