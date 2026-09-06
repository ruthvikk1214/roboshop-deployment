# ------------------------------------------------------------------
# Security Groups for the Roboshop VPC
# ------------------------------------------------------------------

# ALB Security Group – internet‑facing
resource "aws_security_group" "alb_sg" {
  name        = "roboshop-alb-sg"
  description = "Allow inbound HTTP/HTTPS from the Internet to the ALB"
  vpc_id      = aws_vpc.roboshop.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "roboshop-alb-sg"
  }
}

# Worker Nodes Security Group – private, only reachable from the VPC and ALB
resource "aws_security_group" "node_sg" {
  name        = "roboshop-node-sg"
  description = "Security group for EKS worker nodes (private subnets)"
  vpc_id      = aws_vpc.roboshop.id

  # Allow inbound traffic from the ALB security group on any port (K8s service ports)
  ingress {
    description     = "Allow traffic from ALB"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow all traffic within the VPC CIDR (pods can talk to each other)
  ingress {
    description = "VPC intra‑subnet traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.roboshop.cidr_block]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "roboshop-node-sg"
  }
}
