variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-west-2"
}

variable "environment" {
  type        = string
  description = "Environment (dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = var.environment == "dev" || var.environment == "staging" || var.environment == "prod"
    error_message = "Environment variable must be one of (dev, staging, prod)."
  }
}

variable "app_instance_type" {
  type        = string
  description = "Instance type of application server."
  default     = "r5.2xlarge"
}

variable "db_instance_type" {
  type        = string
  description = "Instance type of database server."
  default     = "r5.8xlarge"
}

variable "bastion_instance_type" {
  type        = string
  description = "Instance type of bastion host."
  default     = "t3a.nano"
}

variable "ec2_app_keypair" {
  type        = string
  description = "Key pair for app instance."
}

variable "ec2_db_keypair" {
  type        = string
  description = "Key pair for db instance."
}

variable "ec2_bastion_keypair" {
  type        = string
  description = "Key pair for bastion instance."
}

variable "ec2_bastion_enable" {
  type        = bool
  description = "Flag that enables or disables the bastion host."
  default     = true
}

variable "s3_bucket_name" {
  type        = string
  description = "The base name of the S3 bucket that is being requested. This base name can be made unique by specifing values for either the s3_bucket_prefix_list, the s3_bucket_suffix_list, or both module variables."
}

variable "log_bucket_name" {
  type        = string
  description = "The base name of the S3 bucket that is being requested. This base name can be made unique by specifing values for either the s3_bucket_prefix_list, the s3_bucket_suffix_list, or both module variables."
}

variable "cloudtrail_bucket_name" {
  type        = string
  description = "The base name of the S3 bucket that is being requested. This base name can be made unique by specifing values for either the s3_bucket_prefix_list, the s3_bucket_suffix_list, or both module variables."
}

variable "s3_bucket_prefix_list" {
  type        = list(any)
  description = "A prefix list that will be added to the start of the bucket name. For example if s3_bucket_prefix_list=['test'], then the bucket will be named 'test-$${s3_bucket_name}'. This module will also look for the keywords 'region_prefix' and 'account_prefix' and will substitue the current region, or account_id within the module as in the example: s3_bucket_prefix_list=['test', 'region_prefix', 'account_prefix'], resulting in the bucket 'test-us-east-1-1234567890101-$${s3_bucket_name}'. If left blank no prefix will be added."
  default     = []
}

variable "s3_bucket_suffix_list" {
  type        = list(any)
  description = "A suffix list that will be added to the end of the bucket name. For example if s3_bucket_suffix_list=['test'], then the bucket will be named '$${s3_bucket_name}-test'. This module will also look for the keywords 'region_suffix' and 'account_suffix' and will substitue the current region, or account_id within the module as in the example: s3_bucket_suffix_list=['region_suffix', 'account_suffix', 'test'], resulting in the bucket name '$${s3_bucket_name}-us-east-1-1234567890101-test'. If left blank no suffix will be added."
  default     = []
}

variable "s3_versioning_enabled" {
  type        = bool
  description = "Flag to enable bucket object versioning."
  default     = false
}

variable "s3_mfa_delete" {
  type        = bool
  description = "Flag to enable the requirement of MFA in order to delete a bucket, object, or disable object versioning."
  default     = false
}

variable "s3_force_destroy" {
  type        = bool
  description = "Empty S3 buckets before deleting."
  default     = true
}

variable "s3_kms_key_arn" {
  type        = string
  description = "The key that will be used to encrypt objects within the new bucket. If the default value of AES256 is unchanged, S3 will encrypt objects with the default KMS key. If a KMS CMK ARN is provided, then S3 will encrypt objects with the specified KMS key instead."
  default     = "AES256"
}

variable "s3_bucket_acl" {
  type        = string
  description = "The Access Control List that will be placed on the bucket. Acceptable Values are: 'private', 'public-read', 'public-read-write', 'aws-exec-read', 'authenticated-read', 'bucket-owner-read', 'bucket-owner-full-control', or 'log-delivery-write'"
  default     = "private"
}

variable "s3_shared_principal_list" {
  type        = list(string)
  description = "List of users/roles that will be granted permissions to GET, PUT, and DELETE objects from/to the provisioned S3 bucket."
  default     = []
}

variable "s3_transition_rules" {
  type        = map(any)
  description = "A map of transition rules for the S3 bucket"
  default     = {}
}

variable "s3_bucket_policy" {
  type        = string
  description = "A policy to merge with the bucket policy.  Use %BUCKET% for bucket name"
  default     = null
}

variable "replication_configuration" {
  description = "Map containing cross-region replication configuration."
  type        = any
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "s3_expiration_days" {
  description = "If set, number of days to expire objects"
  type        = number
  default     = null
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "s3_replication_principal_arns" {
  description = "If this bucket is intended as the target of Cross Region Replication, then we a list of allowed principals to replicate to this bucket."
  type        = list(string)
  default     = []
}

variable "enable_cloudwatch_metric_alarm" {
  description = "Determines whether CloudWatch autorecover alarm is provisioned or not"
  type        = bool
  default     = true
}

# Cloudtrail Bucket
variable "cloudtrail_bucket_enabled" {
  description = "Control if the CloudTrail bucket is created or not"
  type        = bool
  default     = false
}

variable "cloudtrail_bucket_acl" {
  description = "the ACL type for the bucket"
  type        = string
  default     = ""
}

variable "cloudtrail_bucket_versioning_enabled" {
  description = "Control if versioning is enabled or not"
  type        = bool
  default     = false
}

variable "cloudtrail_bucket_lifecycle_transition_days" {
  description = "the days before transitioning objects in the bucket"
  type        = string
  default     = ""
}

variable "ec2_delete_volume_on_termination" {
  description = "Delete EBS volumes when EC2 instance is terminated."
  type        = bool
  default     = false
}