##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region.paris
}

##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_availability_zones" "available" {
  state = "available"
}


##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_block
  enable_dns_hostnames = true

  tags = local.common_tags

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.common_tags

}

resource "aws_subnet" "subnet1" {
  cidr_block              = var.vpc_subnets_cidr_block[0]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = local.common_tags
}

resource "aws_subnet" "subnet2" {
  cidr_block              = var.vpc_subnets_cidr_block[1]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = local.common_tags
}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id

}

resource "aws_route_table_association" "rta-subnet2" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id

}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = var.ingress_port_mapping
    to_port     = var.ingress_port_mapping
    protocol    = "tcp"
    cidr_blocks = [var.vpc_block]

  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_security_group" "alb_sg" {
  name   = "nginx_alb_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = var.ingress_port_mapping
    to_port     = var.ingress_port_mapping
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}