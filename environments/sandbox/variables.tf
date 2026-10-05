variable "aws_region" {
  description = "Target AWS region"
  type        = string
  default     = "us-east-1"
}

variable "pr_number" {
  description = "Pull request number"
  type        = string
}

variable "created_at" {
  description = "Stack creation timestamp"
  type        = string
}