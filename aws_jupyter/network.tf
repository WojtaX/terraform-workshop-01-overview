resource "aws_vpc" "terraform_demo_vpc" {
  cidr_block = var.network_address
  tags = {
    Name = var.main_env_tag
  }
}

resource "aws_internet_gateway" "terraform_demo_gateway" {
  vpc_id = aws_vpc.terraform_demo_vpc.id

  tags = {
    Name = var.main_env_tag
  }
}

resource "aws_subnet" "terraform_demo_subnet" {
  vpc_id                  = aws_vpc.terraform_demo_vpc.id
  cidr_block              = var.network_address
  availability_zone       = var.region
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.terraform_demo_gateway]
  tags = {
    Name = var.main_env_tag
  }
}

resource "aws_network_interface" "terraform_demo_interface" {
  subnet_id   = aws_subnet.terraform_demo_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = var.main_env_tag
  }
}

resource "aws_route_table" "terraform_demo_route_table" {
  vpc_id = aws_vpc.terraform_demo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_demo_gateway.id
  }
  tags = {
    Name = var.main_env_tag
  }
}

resource "aws_security_group" "terraform_demo_security_group" {
  vpc_id     = aws_vpc.terraform_demo_vpc.id
  depends_on = [aws_vpc.terraform_demo_vpc]
  ingress {
    description = "allow access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.main_env_tag
  }
}

resource "aws_route_table_association" "terraform_demo_route_association" {
  count          = 2
  subnet_id      = aws_subnet.terraform_demo_subnet.id
  route_table_id = aws_route_table.terraform_demo_route_table.id
}