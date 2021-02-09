resource "aws_route53_zone" "atlantis" {
  name          = "cco-tf-demo.com"
  force_destroy = var.force_destroy

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}