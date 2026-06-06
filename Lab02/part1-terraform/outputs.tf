output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "Private subnet ID"
  value       = module.vpc.private_subnet_id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}

output "public_instance_id" {
  description = "Public EC2 instance ID"
  value       = module.public_ec2.instance_id
}

output "private_instance_id" {
  description = "Private EC2 instance ID"
  value       = module.private_ec2.instance_id
}

output "public_ec2_sg_id" {
  description = "Public EC2 security group ID"
  value       = module.security.public_ec2_sg_id
}

output "private_ec2_sg_id" {
  description = "Private EC2 security group ID"
  value       = module.security.private_ec2_sg_id
}
