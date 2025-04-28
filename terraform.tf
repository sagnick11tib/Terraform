terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "nicks-state-bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "nicks-state-table"
  }
}