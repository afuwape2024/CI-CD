variable "cidr_block" {
  description = "this is cidr range block"
}

variable "aws_vpc" {
  description = "tier2 VPC name"
}

variable "aws_public_subnet_cidr" {
  description = "Public subnet CIDR block"
}

variable "aws_private_subnet_cidr" {
  description = "Private subnet CIDR block"
}

#==============================================================================
#==============================SECOND AVAILABILITY ZONE=========================
variable "aws_availability_zone_1" {
  description = "First availability zone"
  default     = "us-east-2a"
}

variable "aws_public_subnet_cidr_2" {
  description = "Second public subnet CIDR block"
}

variable "aws_private_subnet_cidr_2" {
  description = "Second private subnet CIDR block"
}

variable "aws_availability_zone_2" {
  description = "Second availability zone"
  default     = "us-east-2b"
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name for SSH access"
  type        = string
  default     = null
}



# variable "ig_tier2" {}

# variable "public_subnet" {}
# variable "private_subnet" {}    
# variable "public_subnet2" {}
# variable "private_subnet2" {}