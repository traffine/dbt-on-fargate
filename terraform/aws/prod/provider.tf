provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Env       = "dev"
      App       = "dev-my-elt"
      ManagedBy = "Terraform"
    }
  }

}
