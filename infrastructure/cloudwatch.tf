resource "aws_cloudwatch_metric_alarm" "app_1_system_status_check" {
  alarm_name          = "EC2AutoRecover-${aws_instance.app.id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  alarm_actions = [
    "arn:aws:automate:${data.aws_region.current.name}:ec2:recover",
    "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:ec2autorecovery-sns"
  ]

  threshold         = "1"
  alarm_description = "Auto recover the EC2 instance if Status Check fails."
}

resource "aws_cloudwatch_metric_alarm" "db_1_system_status_check" {
  alarm_name          = "EC2AutoRecover-${aws_instance.db.id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"

  dimensions = {
    InstanceId = aws_instance.db.id
  }

  alarm_actions = [
    "arn:aws:automate:${data.aws_region.current.name}:ec2:recover",
    "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:ec2autorecovery-sns"
  ]

  threshold         = "1"
  alarm_description = "Auto recover the EC2 instance if Status Check fails."
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "cloudtrail/cco-tf-example"
  retention_in_days = 90
}