terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # Backend details injected via GitHub Actions CLI:
    # terraform init -backend-config="bucket=..." -backend-config="key=sandboxes/pr-${PR_NUMBER}/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}