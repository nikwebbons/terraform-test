output "s3_name" {
  value = aws_s3_bucket.terraform_state.arn
}
