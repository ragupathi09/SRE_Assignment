terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"


    }
  }

  backend "s3" {
    bucket = "buckey09"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    #dynamodb_table = "terraformdynamodb"

    encrypt = true
  }

}

provider "aws" {
  region     = "ap-south-1"
  access_key = var.AWS_ACCESS_KEY
  secret_key = var.AWS_SECRET_KEY
}






