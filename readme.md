# Terraform

```:powershell
terraform init
terraform validate

terraform apply -auto-approve -var="access_key=$AWS_ACCESS_KEY" -var="secret_key=$AWS_SECRET_KEY"

terraform show

ssh -i "terraform-practice-keypair.id_rsa" ec2-user@ec2-13-115-247-214.ap-northeast-1.compute.amazonaws.com

terraform destroy -auto-approve
```

```:powershell
git -v
docker -v
node -v
```
