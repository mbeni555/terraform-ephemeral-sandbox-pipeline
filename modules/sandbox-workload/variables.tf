variable "pr_number" {
  description = "Pull Request number creating this ephemeral sandbox"
  type        = string
}

variable "environment" {
  description = "Target deployment environment"
  type        = string
  default     = "sandbox"
}

variable "created_at" {
  description = "Timestamp when the sandbox stack was initiated"
  type        = string
}