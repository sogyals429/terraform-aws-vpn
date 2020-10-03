terraform {
  backend "s3" {
    bucket = "terraform-aws-vpn-tfstate"
    key    = "terraform.tfstate.d"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  version                 = "~> 2.0"
  region                  = "ap-southeast-2"
  shared_credentials_file = "~/.aws/credentials"
}

data "external" "git_branch" {
  program = ["scripts/get_branch.sh"]
}

locals {
  common_tags = {
    Project             = "terraform-aws-vpn"
    Maintainer_Software = "Terraform"
    Revision            = data.external.git_branch.result["output"]
    Project             = "git@github.com:sogyals429/terraform-aws-vpn.git"
  }
}
