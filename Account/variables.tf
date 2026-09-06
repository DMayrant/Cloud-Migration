############################
# AWS REGION
############################

variable "aws_region" {
  description = "Primary AWS region for the migration environment"
  type        = string
  default     = "us-east-1"
}