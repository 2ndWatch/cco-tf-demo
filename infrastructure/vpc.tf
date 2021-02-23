data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "cco-tf-demo"
  cidr = "10.0.15.0/24"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]
  public_subnets   = ["10.0.15.0/28", "10.0.15.32/28", "10.0.15.64/28", "10.0.15.96/28", "10.0.15.128/28"]
  private_subnets  = ["10.0.15.16/28", "10.0.15.48/28", "10.0.15.80/28", "10.0.15.112/28", "10.0.15.144/28"]
  database_subnets = ["10.0.15.160/28", "10.0.15.176/28", "10.0.15.192/28", "10.0.15.208/28", "10.0.15.224/28"]

  create_database_subnet_route_table = true

  enable_nat_gateway = false
  single_nat_gateway = false
  enable_vpn_gateway = false

  # required for endpoints
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_s3_endpoint       = false
  enable_dynamodb_endpoint = false

  enable_ssm_endpoint              = false
  ssm_endpoint_private_dns_enabled = false
  ssm_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  enable_kms_endpoint              = false
  kms_endpoint_private_dns_enabled = false
  kms_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
}
