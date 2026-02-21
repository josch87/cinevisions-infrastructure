resource "aws_vpc" "cinevisions_vpc" {
  cidr_block           = var.cinevisions_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_subnet" "cinevisions_public_subnet_1" {
  vpc_id                  = aws_vpc.cinevisions_vpc.id
  cidr_block              = var.cinevisions_public_subnet_1_cidr
  availability_zone       = var.aws_availability_zones["az1"]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-subnet-1"
  }
}

resource "aws_subnet" "cinevisions_private_subnet_1" {
  vpc_id            = aws_vpc.cinevisions_vpc.id
  cidr_block        = var.cinevisions_private_subnet_1_cidr
  availability_zone = var.aws_availability_zones["az1"]

  tags = {
    Name = "${local.name_prefix}-private-subnet-1"
  }
}

resource "aws_subnet" "cinevisions_public_subnet_2" {
  vpc_id                  = aws_vpc.cinevisions_vpc.id
  cidr_block              = var.cinevisions_public_subnet_2_cidr
  availability_zone       = var.aws_availability_zones["az2"]
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-subnet-2"
  }
}

resource "aws_subnet" "cinevisions_private_subnet_2" {
  vpc_id            = aws_vpc.cinevisions_vpc.id
  cidr_block        = var.cinevisions_private_subnet_2_cidr
  availability_zone = var.aws_availability_zones["az2"]

  tags = {
    Name = "${local.name_prefix}-private-subnet-2"
  }
}

resource "aws_internet_gateway" "cinevisions_igw" {
  vpc_id = aws_vpc.cinevisions_vpc.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_default_route_table" "cinevisions_default_rt" {
  default_route_table_id = aws_vpc.cinevisions_vpc.default_route_table_id

  tags = {
    Name = "${local.name_prefix}-default-rt"
  }
}

resource "aws_route_table" "cinevisions_public_rt" {
  vpc_id = aws_vpc.cinevisions_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cinevisions_igw.id
  }

  tags = {
    Name = "${local.name_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "cinevisions_public_subnet_1_assoc_public_rt" {
  route_table_id = aws_route_table.cinevisions_public_rt.id
  subnet_id      = aws_subnet.cinevisions_public_subnet_1.id
}

resource "aws_route_table_association" "cinevisions_public_subnet_2_assoc_public_rt" {
  route_table_id = aws_route_table.cinevisions_public_rt.id
  subnet_id      = aws_subnet.cinevisions_public_subnet_2.id
}