resource "aws_cloudtrail" "cloudtrail" {
  #checkov:skip=CKV_AWS_35:Cloudtrail is already encrypted with AWS SSE.
  #checkov:skip=CKV_AWS_67:Not needed for DR infrastructure.
  name                          = "cco-tf-example"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = false
  enable_logging                = true
  is_organization_trail         = false
  #   cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}*"
  #   cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail.arn
  #   sns_topic_name = aws_sns_topic.dr.name

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.cloudtrail.arn}/*"]
    }
  }

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

  depends_on = [aws_s3_bucket_policy.cloudtrail]
}

data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cloudtrail" {
  name        = "AccountBaseline-CloudTrail-CloudWatchLogs-Role"
  description = "Allows Cloud Trail to create Log Streams in Cloud Watch Log Groups"

  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json

  tags = merge(
    {
      "Name" = "AccountBaseline-CloudTrail-CloudWatchLogs-Role"
    },
  )
}

data "aws_iam_policy_document" "cloudwatch_logsgroup" {

  statement {
    sid = "AWSCloudTrailCreateLogStreamAndPutEvents"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["${aws_cloudwatch_log_group.cloudtrail.arn}:*"]
  }
}

resource "aws_iam_role_policy" "cloudtrail" {
  name = "AccountBaseline-CloudTrail-CloudWatchLogsGroup-Policy"

  role   = aws_iam_role.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudwatch_logsgroup.json
}