variable "project_name" { type = string }
variable "env" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "db_subnets" { type = list(string) }
variable "region" { type = string }

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.project_name}-vpc"
    Env  = var.env
  }
}

resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => { cidr = cidr, az = data.aws_availability_zones.available.names[idx] } }

  vpc_id = aws_vpc.this.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${each.key}"
    Tier = "public"
  }
}

resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => { cidr = cidr, az = data.aws_availability_zones.available.names[idx] } }

  vpc_id = aws_vpc.this.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.project_name}-private-${each.key}"
    Tier = "private"
  }
}

resource "aws_subnet" "db" {
  for_each = { for idx, cidr in var.db_subnets : idx => { cidr = cidr, az = data.aws_availability_zones.available.names[idx] } }

  vpc_id = aws_vpc.this.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.project_name}-db-${each.key}"
    Tier = "db"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.project_name}-igw" }
}

resource "aws_eip" "nat" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
  tags = { Name = "${var.project_name}-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = { Name = "${var.project_name}-nat" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "${var.project_name}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "${var.project_name}-private-rt" }
}

resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = values(aws_subnet.db)[*].id

  tags = { Name = "${var.project_name}-db-subnet-group" }
}
