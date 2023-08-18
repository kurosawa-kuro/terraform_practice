# variables.tf
# ---------------------------
# 変数設定
# ---------------------------
variable "az_a" {
  default = "ap-northeast-1a"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
}
