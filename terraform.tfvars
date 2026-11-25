########################################
# AWS
########################################

aws_region     = "us-east-1"
aws_account_id = "739786453678"


########################################
# MIGRATION NETWORK
########################################

vpc_cidr     = "10.81.0.0/16"
on_prem_cidr = "172.16.0.0/16"

#######################
# VPN Customer Gateways
#######################
vpn_a_customer_gateway = {
  public_ip = "203.0.113.10"
  bgp_asn   = 65010
}

vpn_b_customer_gateway = {
  public_ip = "198.51.100.20"
  bgp_asn   = 65020
}

########################################
# MGN
########################################

mgn_installation_user = "dmay-admin"

mgn_vpc_cidr = "10.81.0.0/16"

mgn_staging_subnets = {
  a = {
    cidr_block        = "10.81.90.0/24"
    availability_zone = "us-east-1a"
  }
  b = {
    cidr_block        = "10.81.100.0/24"
    availability_zone = "us-east-1b"
  }
}

mgn_endpoint_subnet_ids        = ["subnet-0123456789abcdef0"]
mgn_installer_role_name       = "MGNAgentInstaller"
mgn_endpoint_client_ipv4_cidrs = ["192.168.1.39/32", "10.81.0.0/16"]
mgn_installer_trusted_principal_arn = "arn:aws:iam::739786453678:user/dmay-admin"

########################################
# DIRECT CONNECT
########################################

dx_primary_location   = "EqDC2"
dx_secondary_location = "EqSe2-WBE"

dx_primary_vlan   = 100
dx_secondary_vlan = 200

on_prem_bgp_asn = 65000

enable_direct_connect = false # True to enable DX


########################################
# MIGRATED EC2 WORKLOAD
########################################

migration_ami_id = "ami-068c0051b15cdb816"
instance_type    = "t3.xlarge"