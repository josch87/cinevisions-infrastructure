resource "aws_vpc" "cinevisions_vpc" {
  cidr_block = var.cinevisions_vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "cinevisions-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "cinevisions_public_subnet_1" {
  vpc_id = aws_vpc.cinevisions_vpc.id
  cidr_block = var.cinevisions_public_subnet_1_cidr
  availability_zone = var.aws_availability_zones["az1"]
  map_public_ip_on_launch = true
  tags = {
    Name = "cinevisions-public-subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "cinevisions_private_subnet_1" {
  vpc_id = aws_vpc.cinevisions_vpc.id
  cidr_block = var.cinevisions_private_subnet_1_cidr
  availability_zone = var.aws_availability_zones["az1"]
  map_public_ip_on_launch = true
  tags = {
    Name = "cinevisions-private-subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "cinevisions_public_subnet_2" {
  vpc_id = aws_vpc.cinevisions_vpc.id
  cidr_block = var.cinevisions_public_subnet_2_cidr
  availability_zone = var.aws_availability_zones["az2"]
  map_public_ip_on_launch = true
  tags = {
    Name = "cinevisions-public-subnet-2"
    Environment = var.environment
  }
}

resource "aws_subnet" "cinevisions_private_subnet_2" {
  vpc_id = aws_vpc.cinevisions_vpc.id
  cidr_block = var.cinevisions_private_subnet_2_cidr
  availability_zone = var.aws_availability_zones["az2"]
  map_public_ip_on_launch = true
  tags = {
    Name = "cinevisions-private-subnet-2"
    Environment = var.environment
  }
}