variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region for deployment"
}

variable "aws_profile" {
  type        = string
  default     = "default"
}

variable "project_name" {
  type    = string
  default = "aws-3tier-webapp"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "db_subnets" {
  type    = list(string)
  default = ["10.0.201.0/24", "10.0.202.0/24"]
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
  default     = "ami-0c2b8ca1dad447f8a"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "key_name" {
  type        = string
  description = "Key pair name for EC2"
  default     = "shubham-key"
}

variable "save_private_key_path" {
  type    = string
  default = "./shubham-key.pem"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Allowed IP CIDR for SSH access"
  default     = "203.0.113.10/32" # <-- Change this
}

variable "db_username" {
  type    = string
  default = "appuser"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "CHANGE_ME" # Move to terraform.tfvars
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "alb_certificate_arn" {
  type    = string
  default = ""
}
