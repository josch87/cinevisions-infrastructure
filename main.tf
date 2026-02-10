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
}