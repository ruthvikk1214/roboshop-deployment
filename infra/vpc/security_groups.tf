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

