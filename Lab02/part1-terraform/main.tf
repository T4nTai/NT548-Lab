terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_name            = var.vpc_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

module "security" {
  source           = "./modules/security"
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "public_ec2" {
  source                      = "./modules/ec2"
  name                        = "public-instance"
  ami_id                      = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnet_id
  security_group_ids          = [module.security.public_ec2_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
}

module "private_ec2" {
  source                      = "./modules/ec2"
  name                        = "private-instance"
  ami_id                      = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.private_subnet_id
  security_group_ids          = [module.security.private_ec2_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = false
}
