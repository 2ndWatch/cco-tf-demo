terraform {
  required_version = "~>0.14"

  backend "s3" {
    bucket = "terraform-state-laiello2wsandbox"
    region = "us-east-1"
    key    = "cco-tf-demo/infrastructure"
  }

  required_providers {
    aws = {
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_organizations_organization" "current" {}