output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "alb_controller_role_arn" {
  description = "IAM Role ARN for the AWS Load Balancer Controller"
  value       = module.alb_controller_irsa_role.iam_role_arn
}
