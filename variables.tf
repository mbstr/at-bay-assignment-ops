variable "aws_account_access_key" {
  description = "AWS account access key"
  type        = string
  nullable    = false
}

variable "aws_account_secret_key" {
  description = "AWS account secret key"
  type        = string
  nullable    = false
}

variable "hello_world_deployment_region" {
  description = "AWS region where Hello World website is deployed."
  type        = string
  nullable    = false
  default     = "eu-west-1"
}

variable "hello_world_s3_bucket_name" {
  description = "AWS S3 bucket name where Hello World website content is stored."
  type        = string
  nullable    = false
  default     = "hello-world-host"
  validation {
    condition     = length(var.hello_world_s3_bucket_name) < 63
    error_message = "The Hello World static site bucket name is too long."
  }
}

variable "hello_world_site_content" {
  description = "AWS S3 bucket object serving as access point to Hello World website."
  type        = string
  nullable    = false
  default     = "index.html"
}

variable "hello_world_site_content_source" {
  description = "Local files to place in a bucket when deploying new site content."
  type        = string
  nullable    = false
}
