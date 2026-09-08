# ------------------------------------------------------------------
# VPC – same CIDR as before
# ------------------------------------------------------------------
resource "aws_vpc" "roboshop" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "roboshop-vpc"
  }
}

# ------------------------------------------------------------------
# Data source – fetch available AZs in the region
# ------------------------------------------------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

# ------------------------------------------------------------------
# Variable – number of AZs to use (default 2)
# ------------------------------------------------------------------
variable "az_count" {
  description = "Number of AZs to deploy into"
  type        = number
  default     = 2
}

# ------------------------------------------------------------------
# Compute the list of AZ names we will use (first N AZs)
# ------------------------------------------------------------------
locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

# ------------------------------------------------------------------
# PUBLIC SUBNETS – one per selected AZ (for the ALB)
# ------------------------------------------------------------------
resource "aws_subnet" "public" {
  for_each = toset(local.selected_azs)

  vpc_id                  = aws_vpc.roboshop.id
  cidr_block              = cidrsubnet(aws_vpc.roboshop.cidr_block, 8, index(local.selected_azs, each.key) + 1) # 10.0.1.0/24, 10.0.2.0/24, …
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "roboshop-public-${each.key}"
  }
}

# ------------------------------------------------------------------
# PRIVATE SUBNETS – one per selected AZ (for the worker nodes)
# ------------------------------------------------------------------
resource "aws_subnet" "private" {
  for_each = toset(local.selected_azs)

  vpc_id            = aws_vpc.roboshop.id
  cidr_block        = cidrsubnet(aws_vpc.roboshop.cidr_block, 8, index(local.selected_azs, each.key) + var.az_count + 1) # 10.0.3.0/24, 10.0.4.0/24, …
  availability_zone = each.key

  tags = {
    Name = "roboshop-private-${each.key}"
  }
}

# ------------------------------------------------------------------
# INTERNET GATEWAY (for public subnets)
# ------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.roboshop.id
  tags   = { Name = "roboshop-igw" }
}

# ------------------------------------------------------------------
# PUBLIC ROUTE TABLE (0.0.0.0/0 → IGW)
# ------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.roboshop.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "roboshop-public-rt" }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ------------------------------------------------------------------
# PRIVATE ROUTE TABLE (via NAT Gateway)
# ------------------------------------------------------------------

# Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags   = { Name = "roboshop-nat-eip" }
}

# NAT Gateway in the first public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[local.selected_azs[0]].id
  tags          = { Name = "roboshop-nat" }
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.roboshop.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "roboshop-private-rt" }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
