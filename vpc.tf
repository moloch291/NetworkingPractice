# VPC:
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

# Public subnet 1:
resource "aws_subnet" "public_subnet_1" {
  depends_on = [aws_vpc.main,]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "public-subnet-1"
  }

  map_public_ip_on_launch = true
}

# Public subnet 2:
resource "aws_subnet" "public_subnet_2" {
  depends_on = [aws_vpc.main,]

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "public-subnet-2"
  }

  map_public_ip_on_launch = true
}

# Private subnet 1:
resource "aws_subnet" "private_subnet_1" {
  depends_on = [aws_vpc.main,]

  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private-subnet-1"
  }
}

# Private subnet 2:
resource "aws_subnet" "private_subnet_2" {
  depends_on = [aws_vpc.main,]

  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"

  tags = {
    Name = "private-subnet-2"
  }
}