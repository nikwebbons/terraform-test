// Add in any variables required to change the configuration of the terraform deployment
// Required variable do not require a default statement

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "Region in which to create resources"
}

variable "iam_role_name" {
  type        = string
  description = "Name for the IAM role"
}
