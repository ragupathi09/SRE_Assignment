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
    dynamodb_table = "terraformdynamodb"

    encrypt = true
  }

}

provider "aws" {
  region     = "us-west-2"
 
}






