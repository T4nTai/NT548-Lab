variable "name" {
  description = "Name and role tag for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be placed"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "Name of the EC2 key pair for SSH access"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public IP address"
  type        = bool
  default     = false
}

variable "extra_tags" {
  description = "Additional tags to apply to the instance"
  type        = map(string)
  default     = {}
}
