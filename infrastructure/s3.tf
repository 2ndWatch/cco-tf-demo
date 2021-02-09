resource "aws_s3_bucket" "cloudtrail" {
  #checkov:skip=CKV_AWS_52:MFA Delete
  #checkov:skip=CKV_AWS_21:Versioning
  bucket        = var.cloudtrail_bucket_name
  acl           = var.s3_bucket_acl
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.s3_kms_key_arn
      }
    }
  }

  lifecycle_rule {
    prefix  = "cloudtrail/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 90
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 180
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log.id
    target_prefix = "cloudtrail-logs/"
  }
}

#tfsec:ignore:AWS002
resource "aws_s3_bucket" "log" {
  #checkov:skip=CKV_AWS_18:MFA Delete
  #checkov:skip=CKV_AWS_52:Access Logging
  #checkov:skip=CKV_AWS_21:Versioning
  bucket        = var.log_bucket_name
  acl           = "log-delivery-write"
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.s3_kms_key_arn
      }
    }
  }

  lifecycle_rule {
    id      = "log"
    enabled = true
    prefix  = "log/"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 180
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_bucket_policy" {
  statement {
    sid = "DenyNonSecureTransport"

    effect = "Deny"

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.cloudtrail.arn,
      "${aws_s3_bucket.cloudtrail.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }

  statement {
    sid = "AWSCloudTrailAclCheckForCloudTrail"

    actions = ["s3:GetBucketAcl"]

    resources = [aws_s3_bucket.cloudtrail.arn]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    sid = "AWSCloudTrailWriteForCloudTrail"

    actions = ["s3:PutObject"]

    resources = ["${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

data "aws_iam_policy_document" "logging_bucket_policy" {
  statement {
    sid = "DenyNonSecureTransport"

    effect = "Deny"

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.log.arn,
      "${aws_s3_bucket.log.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [
        "false"
      ]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.log.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket     = aws_s3_bucket.cloudtrail.id
  policy     = data.aws_iam_policy_document.cloudtrail_bucket_policy.json
  depends_on = [aws_s3_bucket_public_access_block.cloudtrail]
}

resource "aws_s3_bucket_policy" "logging" {
  bucket     = aws_s3_bucket.log.id
  policy     = data.aws_iam_policy_document.logging_bucket_policy.json
  depends_on = [aws_s3_bucket_public_access_block.logging]
}