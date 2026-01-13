# SNS Topic for alerts
resource "aws_sns_topic" "s3_object_lock_alerts" {
  name = "s3-object-lock-compliance-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.s3_object_lock_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# EventBridge Rule to monitor S3 object lock changes
resource "aws_cloudwatch_event_rule" "s3_object_lock_changes" {
  name        = "s3-object-lock-compliance-monitor"
  description = "Monitor S3 object lock configuration changes"

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["s3.amazonaws.com"]
      eventName = [
        "PutObjectLockConfiguration",
        "PutBucketObjectLockConfiguration",
        "DeleteObjectLockConfiguration",
        "PutBucketVersioning"
      ]
      requestParameters = {
        bucketName = var.monitored_bucket_names
      }
    }
  })
}

# EventBridge Target - SNS
resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.s3_object_lock_changes.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.s3_object_lock_alerts.arn

  input_transformer {
    input_paths = {
      bucket     = "$.detail.requestParameters.bucketName"
      event_name = "$.detail.eventName"
      user       = "$.detail.userIdentity.userName"
      time       = "$.detail.eventTime"
      account    = "$.detail.recipientAccountId"
    }
    input_template = "\"ALERT: S3 Object Lock configuration changed on bucket '<bucket>' in account '<account>' by user '<user>' at <time>. Event: <event_name>\""
  }
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "s3_object_lock_alerts_policy" {
  arn = aws_sns_topic.s3_object_lock_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.s3_object_lock_alerts.arn
      }
    ]
  })
}
