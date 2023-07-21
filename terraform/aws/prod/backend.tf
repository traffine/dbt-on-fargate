terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      version = "~> 3.40.0"
    }
  }

  backend "s3" {
    bucket         = "prod-my-elt-tfstate"
    dynamodb_table = "prod-my-elt-tfstate"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }
}
