# vpc.tf
# ---------------------------
# VPC
# ---------------------------
resource "aws_vpc" "practice_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true # DNSホスト名を有効化
  tags = {
    Name = "terraform-practice-vpc"
  }
}

# ---------------------------
# Subnet
# ---------------------------
resource "aws_subnet" "practice_public_1a_sn" {
  vpc_id            = aws_vpc.practice_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az_a

  tags = {
    Name = "terraform-practice-public-1a-sn"
  }
}

# ---------------------------
# Internet Gateway
# ---------------------------
resource "aws_internet_gateway" "practice_igw" {
  vpc_id = aws_vpc.practice_vpc.id
  tags = {
    Name = "terraform-practice-igw"
  }
}

# ---------------------------
# Route table
# ---------------------------
# Route table作成
resource "aws_route_table" "practice_public_rt" {
  vpc_id = aws_vpc.practice_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.practice_igw.id
  }
  tags = {
    Name = "terraform-practice-public-rt"
  }
}

# SubnetとRoute tableの関連付け
resource "aws_route_table_association" "practice_public_rt_associate" {
  subnet_id      = aws_subnet.practice_public_1a_sn.id
  route_table_id = aws_route_table.practice_public_rt.id
}

# ---------------------------
# Security Group
# ---------------------------
# 自分のパブリックIP取得
data "http" "ifconfig" {
  url = "http://ipv4.icanhazip.com/"
}

variable "allowed_cidr" {
  default = null
}

# locals {
#   myip         = chomp(data.http.ifconfig.body)
#   allowed_cidr = (var.allowed_cidr == null) ? "${local.myip}/32" : var.allowed_cidr
# }

locals {
  myip         = chomp(data.http.ifconfig.body)
  allowed_cidr = (var.allowed_cidr == null) ? "${local.myip}/32" : var.allowed_cidr
}

# Security Group作成
resource "aws_security_group" "practice_ec2_sg" {
  name        = "terraform-practice-ec2-sg"
  description = "For EC2 Linux"
  vpc_id      = aws_vpc.practice_vpc.id
  tags = {
    Name = "terraform-practice-ec2-sg"
  }

  # インバウンドルール
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.allowed_cidr]
  }

  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
