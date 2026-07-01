variable "tier2_vpc" {}
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
}
variable "ami" {
  default = "ami-0fe18bc3cfa53a248"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_pair_name" {
  description = "Existing EC2 key pair name to attach to instances"
  type        = string
  default     = null
}
variable "sonarqube_instance_type" {
  default = "t2.medium"
}
variable "sonarqube_ami" {
  default = "ami-0e5497a77ef21b5ac"
}

variable "tier2_public_sg" {}
variable "prometheus_sg" {}
variable "grafana_sg" {}
variable "sonarque_sg" {}
variable "nexus_sg" {}

variable "public_subnet" {
  description = "Public subnet ID for EC2 instances"
}

variable "mandatory_tags" {
  description = "Mandatory tags to apply to resources"
  type        = map(string)
}