terraform {
  required_version = "1.12.2"
  backend "s3" {
    bucket = "my-manage-app-terraform"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.8.0"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = local.default_tags
  }
}
