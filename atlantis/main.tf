terraform {
  required_version = "~>0.14"

  backend "s3" {
    bucket = "terraform-state-laiello2wsandbox"
    region = "us-east-1"
    key    = "cco-tf-demo/atlantis"
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

##############################################################
# Data sources for existing resources
##############################################################

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_elb_service_account" "current" {}

data "terraform_remote_state" "infra" {
  backend = "s3"

  config = {
    bucket = "terraform-state-laiello2wsandbox"
    key = "cco-tf-demo/infrastructure"
		region = "us-east-1"
  }
}

##############################################################
# Atlantis Service
##############################################################

module "atlantis" {
  source  = "terraform-aws-modules/atlantis/aws"
  version = "~> 2.0"

  name = "atlantis"

	vpc_id             = data.terraform_remote_state.infra.outputs.vpc_id
	private_subnet_ids = data.terraform_remote_state.infra.outputs.private_subnet_ids
	public_subnet_ids  = data.terraform_remote_state.infra.outputs.public_subnet_ids

  # DNS (without trailing dot)
  route53_zone_name = data.terraform_remote_state.infra.outputs.route53_zone_name

  # ACM (SSL certificate) - Specify ARN of an existing certificate or new one will be created and validated using Route53 DNS
  certificate_arn = "arn:aws:acm:eu-west-1:135367859851:certificate/70e008e1-c0e1-4c7e-9670-7bb5bd4f5a84"

  # Atlantis
  atlantis_github_user       = "atlantis-bot"
  atlantis_github_user_token = "examplegithubtoken"
  atlantis_repo_whitelist    = ["github.com/terraform-aws-modules/*"]
}