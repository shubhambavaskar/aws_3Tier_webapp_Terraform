variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1" # Mumbai by default; change if required
}

provider "aws" {
  region = var.region
}
