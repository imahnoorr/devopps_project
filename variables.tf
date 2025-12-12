# AWS region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

# Bucket name (must match existing bucket)
variable "bucket_name" {
  description = "Name of the existing S3 bucket"
  type        = string
}
