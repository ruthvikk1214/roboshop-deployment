#!/usr/bin/env bash
set -euo pipefail

# Change to repo root (assumes script lives in scripts/ folder)
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# 1. Install the AWS Load Balancer Controller via Helm
helm repo add eks https://aws.github.io/eks-charts
helm repo update

CLUSTER_NAME=$(terraform output -raw cluster_name)
REGION=$(terraform output -raw aws_region 2>/dev/null || echo "us-east-1")
VPC_ID=$(terraform output -raw vpc_id)

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --create-namespace \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=true \
  --set serviceAccount.name=alb-controller-sa \
  --set region=$REGION \
  --set vpcId=$VPC_ID \
  --set defaultIngressClass=true

# 2. Deploy the Roboshop Helm chart
helm upgrade --install roboshop ./helm-roboshop \
  --namespace roboshop --create-namespace \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=roboshop.rk1214.in

# 3. Wait for ALB to be provisioned
echo "Waiting for ALB 'roboshop-alb' to be provisioned..."
sleep 15
until aws elbv2 describe-load-balancers --names roboshop-alb --region $REGION >/dev/null 2>&1; do
  echo "Still waiting for ALB..."
  sleep 10
done
aws elbv2 wait load-balancer-available --names roboshop-alb --region $REGION

# 4. Apply Route53 Terraform
echo "Creating Route53 Alias Record..."
cd infra/route53
terraform init
terraform apply -var="hosted_zone_id=Z031906510N5GWM6MW07L" -auto-approve
echo "Deployment Complete! DNS will propagate shortly."
