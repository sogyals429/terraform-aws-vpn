terraform {
  backend "s3" {
    bucket = "terraform-aws-vpn-tfstate"
    key = "terraform.tfstate.d"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  version = "~> 2.0"
  region = "ap-southeast-2"
  shared_credentials_file = "~/.aws/credentials"
}

locals {
  common_tags = {
    Project = "terraform-aws-vpn"
    Maintainer_Software = "Terraform"
    Project = "git@github.com:sogyals429/terraform-aws-vpn.git"
  }
}
