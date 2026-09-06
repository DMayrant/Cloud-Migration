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


########################################
# MGN
########################################

mgn_installation_user = "dmay-admin"

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