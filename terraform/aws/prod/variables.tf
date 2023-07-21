variable "aws_account_name" {
  default = 123456789012
}

variable "env" {
  default = "prod"
}

variable "app_name" {
  default = "my-elt"
}


variable "azs" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
