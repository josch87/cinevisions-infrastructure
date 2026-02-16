resource "aws_vpc" "cinevisions_vpc" {
  cidr_block           = var.cinevisions_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "cinevisions-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "cinevisions_public_subnet_1" {
  vpc_id                  = aws_vpc.cinevisions_vpc.id
  cidr_block              = var.cinevisions_public_subnet_1_cidr
  availability_zone       = var.aws_availability_zones["az1"]
  map_public_ip_on_launch = true
  tags = {
    Name        = "cinevisions-public-subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "cinevisions_private_subnet_1" {
  vpc_id                  = aws_vpc.cinevisions_vpc.id
  cidr_block              = var.cinevisions_private_subnet_1_cidr
  availability_zone       = var.aws_availability_zones["az1"]
  map_public_ip_on_launch = true
  tags = {
    Name        = "cinevisions-private-subnet-1"
    Environment = var.environment
  }
}

resource "aws_subnet" "cinevisions_public_subnet_2" {
  vpc_id                  = aws_vpc.cinevisions_vpc.id
  cidr_block              = var.cinevisions_public_subnet_2_cidr
  availability_zone       = var.aws_availability_zones["az2"]
  map_public_ip_on_launch = true
  tags = {
    Name        = "cinevisions-public-subnet-2"
    Environment = var.environment
  }
}

resource "aws_subnet" "cinevisions_private_subnet_2" {
  vpc_id                  = aws_vpc.cinevisions_vpc.id
  cidr_block              = var.cinevisions_private_subnet_2_cidr
  availability_zone       = var.aws_availability_zones["az2"]
  map_public_ip_on_launch = true
  tags = {
    Name        = "cinevisions-private-subnet-2"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "cinevisions_igw" {
  vpc_id = aws_vpc.cinevisions_vpc.id
  tags = {
    Name        = "cinevisions-igw"
    Environment = var.environment
  }
}

resource "aws_default_route_table" "cinevisions_default_rt" {
  default_route_table_id = aws_vpc.cinevisions_vpc.default_route_table_id
  tags = {
    Name        = "cinevisions-default-rt"
    Environment = var.environment
  }
}

resource "aws_route_table" "cinevisions_public_rt" {
  vpc_id = aws_vpc.cinevisions_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cinevisions_igw.id
  }
  tags = {
    Name        = "cinevisions-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "cinevisions_public_subnet_1_rt_association" {
  route_table_id = aws_route_table.cinevisions_public_rt.id
  subnet_id      = aws_subnet.cinevisions_public_subnet_1.id
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.cinevisions_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "webserver-sg"
    Environment = var.environment
  }
}

data "aws_ami" "amazon-linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "cinevisions_web_server" {
  ami                    = data.aws_ami.amazon-linux_2023.id
  instance_type          = var.cinevisions_web_server_instance_type
  subnet_id              = aws_subnet.cinevisions_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  key_name               = "vockey"
  user_data              = file("user-data.sh")
  tags = {
    Name        = "cinevisions-web-server"
    Environment = var.environment
  }
}