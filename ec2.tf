# ---------------------------
# EC2 Key pair
# ---------------------------
variable "key_name" {
  default = "terraform-practice-keypair"
}

# 秘密鍵のアルゴリズム設定
resource "tls_private_key" "practice_private_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

locals {
  public_key_file  = "C:\\Users\\kuros\\Downloads\\Development\\Terraform\\terraform_practice\\${var.key_name}.id_rsa.pub"
  private_key_file = "C:\\Users\\kuros\\Downloads\\Development\\Terraform\\terraform_practice\\${var.key_name}.id_rsa"
}

resource "local_file" "practice_private_key_pem" {
  filename = local.private_key_file
  content  = tls_private_key.practice_private_key.private_key_pem
}

resource "aws_key_pair" "practice_keypair" {
  key_name   = var.key_name
  public_key = tls_private_key.practice_private_key.public_key_openssh
}

# ---------------------------
# EC2
# ---------------------------
# Amazon Linux 2 の最新版AMIを取得
data "aws_ssm_parameter" "amzn2_latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# EC2作成
resource "aws_instance" "practice_ec2" {
  ami                         = data.aws_ssm_parameter.amzn2_latest_ami.value
  instance_type               = "t2.micro"
  availability_zone           = var.az_a
  vpc_security_group_ids      = [aws_security_group.practice_ec2_sg.id]
  subnet_id                   = aws_subnet.practice_public_1a_sn.id
  associate_public_ip_address = "true"
  key_name                    = var.key_name
  tags = {
    Name = "terraform-practice-ec2"
  }
  user_data = <<-EOF
              #!/bin/bash
              # update
              sudo yum update -y

              # install git
              sudo yum install git -y

              # install docker
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user

              # install nodejs
              curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
              sudo yum install -y nodejs
              EOF
}
