terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.10.0"
    }
  }

  backend "s3" {
	bucket="trashpanda-us-west-2-tf-state"
	dynamodb_table="trashpanda-us-west-2-tf-state"
	region="us-west-2"
	key = "trashpanda/terraform.tfstate"
	encrypt="true"
	}
}

provider "aws" {
}
