############################
# AWS REGION
############################

variable "aws_region" {
  description = "Primary AWS region for the migration environment"
  type        = string
  default     = "us-east-1"
}

###################
# Migrated Workloads
###################

variable "migration_ami_id" {
  description = "AMI used to represent the migrated application servers"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for migrated application servers"
  type        = string
  default     = "t3.micro"
}

########################################
# AWS ACCOUNT
########################################

variable "aws_account_id" {
  description = "AWS account ID for the migration environment"
  type        = string
}

########################################
# MGN INSTALLATION USER
########################################

variable "mgn_installation_user" {
  description = "IAM user used for MGN agent installation"
  type        = string
}

############################
# VPC
############################

variable "vpc_cidr" {
  description = "CIDR block for the migration VPC"
  type        = string
  default     = "10.81.0.0/16"
}

############################
# ON-PREMISES NETWORK
############################

variable "on_prem_cidr" {
  description = "CIDR block for on-premises source servers"
  type        = string
}

variable "on_prem_bgp_asn" {
  description = "BGP ASN for the on-premises router"
  type        = number
  default     = 65000
}


############################
# DIRECT CONNECT
############################

variable "dx_primary_location" {
  description = "AWS Direct Connect location code for the primary connection"
  type        = string
}

variable "dx_secondary_location" {
  description = "AWS Direct Connect location code for the secondary connection"
  type        = string
}

variable "dx_primary_vlan" {
  description = "VLAN ID for the primary Direct Connect private VIF"
  type        = number
  default     = 100
}

variable "dx_secondary_vlan" {
  description = "VLAN ID for the secondary Direct Connect private VIF"
  type        = number
  default     = 200
}

######################################
# NO Physical Equipment behind a CGW
######################################

variable "enable_direct_connect" {
  description = "Enable provisioning of AWS Direct Connect resources"
  type        = bool
  default     = false
}