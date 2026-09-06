########################
# ALB SECURITY GROUP
########################

resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.migration.id

  tags = {
    Name        = "alb-sg"
    Environment = "production"
  }
}


########################
# Internet -> ALB
# HTTP 80
########################

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTP from Internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


########################
# Internet -> ALB
# HTTPS 443
########################

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS from Internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}


########################
# ALB EGRESS
########################

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id

  description = "Allow outbound traffic from ALB"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}


########################################
# MIGRATED WORKLOAD SECURITY GROUP
########################################

resource "aws_security_group" "migration_workload" {
  name        = "migration-workload-sg"
  description = "Security group for migrated application workloads"
  vpc_id      = aws_vpc.migration.id

  tags = {
    Name        = "migration-workload-sg"
    Environment = "production"
  }
}


########################################
# ALB -> MIGRATED WORKLOAD
# HTTP 80
########################################

resource "aws_vpc_security_group_ingress_rule" "workload_from_alb" {
  security_group_id = aws_security_group.migration_workload.id

  description                  = "Allow HTTP from ALB"
  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}


########################################
# MIGRATED WORKLOAD -> HTTPS
# SSM / AWS SERVICES
########################################

resource "aws_vpc_security_group_egress_rule" "workload_https" {
  security_group_id = aws_security_group.migration_workload.id

  description = "HTTPS access for SSM and AWS services"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}


########################################
# MGN REPLICATION SECURITY GROUP
########################################

resource "aws_security_group" "mgn_replication" {
  name        = "mgn-replication-sg"
  description = "Security group for MGN replication servers"
  vpc_id      = aws_vpc.migration.id

  tags = {
    Name        = "mgn-replication-sg"
    Environment = "migration"
  }
}


########################################################
# ON-PREM SOURCE SERVERS -> MGN REPLICATION SERVERS
# TCP 1500 over Direct Connect
########################################################

resource "aws_vpc_security_group_ingress_rule" "mgn_replication_1500" {
  security_group_id = aws_security_group.mgn_replication.id

  description = "MGN replication from on-premises over Direct Connect"

  cidr_ipv4   = var.on_prem_cidr
  from_port   = 1500
  to_port     = 1500
  ip_protocol = "tcp"
}


########################################
# MGN REPLICATION -> HTTPS
# AWS MGN / AWS SERVICES
########################################

resource "aws_vpc_security_group_egress_rule" "mgn_https" {
  security_group_id = aws_security_group.mgn_replication.id

  description = "HTTPS access to AWS services"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}


########################################
# SSM VPC ENDPOINT SECURITY GROUP
########################################

resource "aws_security_group" "ssm_endpoints" {
  name        = "ssm-endpoints-sg"
  description = "Security group for SSM VPC endpoints"
  vpc_id      = aws_vpc.migration.id

  tags = {
    Name        = "ssm-endpoints-sg"
    Environment = "production"
  }
}


################################################
# MIGRATED WORKLOADS -> SSM ENDPOINTS
# TCP 443
################################################

resource "aws_vpc_security_group_ingress_rule" "ssm_https" {
  security_group_id = aws_security_group.ssm_endpoints.id

  description                  = "HTTPS from migrated workloads"
  referenced_security_group_id = aws_security_group.migration_workload.id

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}