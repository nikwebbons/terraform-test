// Add in any variables required to change the configuration of the terraform deployment
// Required variable do not require a default statement

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "Region in which to create resources"
}

# variable "iam_role_name" {
#   type        = string
#   description = "Name for the IAM role"
# }

variable "alert_email" {
  description = "Email address to receive S3 object lock compliance alerts"
  type        = string
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "s3-monitoring"
}

variable "monitored_bucket_names" {
  description = "List of S3 bucket names to monitor for object lock changes"
  type        = list(string)
}
