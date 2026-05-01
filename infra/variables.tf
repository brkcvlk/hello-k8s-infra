variable "project" {
  description = "Project name used for resource naming/tagging."
  type        = string
  default     = "hello-k8s"
}

variable "stack" {
  description = "Logical stack name (naming/tagging only)."
  type        = string
  default     = "platform"
}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "hello-k8s"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}


