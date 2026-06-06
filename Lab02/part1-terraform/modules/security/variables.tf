variable "vpc_id" {
  description = "VPC ID to create security groups in"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the public EC2 instance"
  type        = string
}

variable "public_instance_sg_id" {
  description = "Security group ID of the public EC2 instance (used to allow private EC2 access)"
  type        = string
  default     = ""
}
