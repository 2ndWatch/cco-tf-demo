region                           = "us-east-1"
environment                      = "staging"
app_instance_type                = "t3.small"
db_instance_type                 = "t3.small"
bastion_instance_type            = "t3a.micro"
ec2_delete_volume_on_termination = true
ec2_app_keypair                  = "app-staging-key"
ec2_db_keypair                   = "db-staging-key"
ec2_bastion_keypair              = "bastion-staging-key"
s3_bucket_name                   = "cco-tf-demo-staging"
log_bucket_name                  = "cco-tf-demo-log-staging"
cloudtrail_bucket_name           = "cco-tf-demo-cloudtrail-staging"
s3_bucket_prefix_list            = []
s3_bucket_suffix_list            = ["staging"]
s3_versioning_enabled            = false
s3_mfa_delete                    = false
s3_kms_key_arn                   = "AES256"
s3_shared_principal_list         = ["*"]
enable_cloudwatch_metric_alarm   = true
s3_force_destroy                 = true