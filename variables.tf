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
  description = "Name for the key pair to use for EC2"
  default     = "shubham-key" # <<< CHANGE if you want different name
}

variable "save_private_key_path" {
  type    = string
  default = "./shubham-key.pem" # private key will be saved here (local_file)
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "YOUR_IP/32" # <<< CHANGE THIS to your public IP/CIDR (ex: 203.0.113.5/32)
}

variable "db_username" {
  type    = string
  default = "appuser"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "My@passwd" # <<< CHANGE THIS in terraform.tfvars (do not commit)
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
  default = "" # optional - if using HTTPS, provide ACM certificate ARN
}
