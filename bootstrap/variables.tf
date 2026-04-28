variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "tfstate_bucket_name" {
  description = "Globally-unique S3 bucket name for Terraform state."
  type        = string
}
