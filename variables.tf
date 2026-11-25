############################
# AWS REGION
############################

variable "aws_region" {
  description = "Primary AWS region for the migration environment"
  type        = string
  default     = "us-east-1"
}

#######################
# Migrated Workloads
#######################

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

###############
# MGN Variables
################

variable "mgn_installer_role_name" {
  description = "Name of the existing IAM role whose temporary credentials are used to install replication agents."
  type        = string
}

variable "mgn_installer_trusted_principal_arn" {
  description = "ARN of the existing IAM principal allowed to assume the installer role."
  type        = string
}

variable "mgn_endpoint_subnet_ids" {
  description = "Staging VPC subnet IDs for endpoint interfaces. Choose at most one subnet per Availability Zone."
  type        = set(string)
}

variable "mgn_endpoint_client_ipv4_cidrs" {
  description = "IPv4 CIDRs allowed to reach the MGN endpoint, including on-premises source networks and staging clients that use it."
  type        = set(string)
}

variable "mgn_vpc_cidr" {
  type = string
}

variable "mgn_staging_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

##########
# AWS VPN's 
##########

variable "vpn_a_customer_gateway" {
  description = "Public IPv4 address and BGP ASN for on-premises edge router A."
  type = object({
    public_ip = string
    bgp_asn   = number
  })
}
variable "vpn_b_customer_gateway" {
  description = "Public IPv4 address and BGP ASN for edge router B."
  type = object({
    public_ip = string
    bgp_asn   = number
  })
}

