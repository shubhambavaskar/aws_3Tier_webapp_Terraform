# MODULE: VPC
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  env          = var.env
  vpc_cidr     = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  db_subnets = var.db_subnets
  region = var.region
}

# MODULE: SECURITY
module "security" {
  source    = "./modules/security"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# MODULE: RDS
module "rds" {
  source = "./modules/rds"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  db_subnet_ids = module.vpc.db_subnet_ids
  db_sg_id = module.security.db_sg_id
  db_username = var.db_username
  db_password = var.db_password
  db_allocated_storage = var.db_allocated_storage
  db_instance_class = var.db_instance_class
  env = var.env
}

# MODULE: EC2 + ASG + ALB
module "ec2_asg_alb" {
  source = "./modules/ec2_asg_alb"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  web_sg_id = module.security.web_sg_id
  alb_sg_id = module.security.alb_sg_id
  db_endpoint = module.rds.db_endpoint
  instance_type = var.instance_type
  key_name = var.key_name
  desired_capacity = var.desired_capacity
  asg_min_size = var.asg_min_size
  asg_max_size = var.asg_max_size
  env = var.env
  alb_certificate_arn = var.alb_certificate_arn
}

# CREATE SSH KEYPAIR LOCALLY (tls private key + aws_key_pair + save file)
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = var.save_private_key_path
  file_permission = "0400"
}

# OUTPUTS
output "alb_dns_name" {
  value = module.ec2_asg_alb.alb_dns
}

output "db_endpoint" {
  value     = module.rds.db_endpoint
  sensitive = true
}

output "private_key_path" {
  value = local_file.private_key_pem.filename
}
