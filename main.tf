# main.tf

# ---------------------------
# プロバイダ設定
# ---------------------------
# AWS
provider "aws" {
  region = "ap-northeast-1"
}

# 自分のパブリックIP取得用
provider "http" {}

# module "ec2" {
#   source = "./modules/ec2"
#   # その他の変数や設定
# }

# module "vpc" {
#   source = "./modules/vpc"
#   # その他の変数や設定
# }
