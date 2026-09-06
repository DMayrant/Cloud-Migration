########################################
# VPC
########################################

output "vpc_id" {
  description = "ID of the migration VPC"
  value       = aws_vpc.migration.id
}

output "vpc_cidr" {
  description = "CIDR block of the migration VPC"
  value       = aws_vpc.migration.cidr_block
}

########################################
# SUBNETS
########################################

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value = [
    aws_subnet.public.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_id" {
  description = "ID of the private workload subnet"
  value       = aws_subnet.private.id
}

output "mgn_staging_subnet_id" {
  description = "ID of the MGN staging subnet"
  value       = aws_subnet.mgn_staging.id
}

########################################
# APPLICATION LOAD BALANCER
########################################

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "ARN of the migration application target group"
  value       = aws_lb_target_group.app_tg.arn
}

########################################
# MIGRATED EC2 SERVERS
########################################

output "migration_server_1_id" {
  description = "Instance ID of migration server 1"
  value       = aws_instance.migration_server_1.id
}

output "migration_server_2_id" {
  description = "Instance ID of migration server 2"
  value       = aws_instance.migration_server_2.id
}

output "migration_server_private_ips" {
  description = "Private IP addresses of migrated EC2 servers"
  value = [
    aws_instance.migration_server_1.private_ip,
    aws_instance.migration_server_2.private_ip
  ]
}

########################################
# DIRECT CONNECT
########################################

output "dx_gateway_id" {
  description = "ID of the Direct Connect Gateway"
  value       = aws_dx_gateway.migration.id
}

output "virtual_private_gateway_id" {
  description = "ID of the Virtual Private Gateway"
  value       = aws_vpn_gateway.migration.id
}

########################################
# DIRECT CONNECT CONNECTIONS
########################################

output "primary_dx_connection_id" {
  description = "Primary Direct Connect connection ID when DX is enabled"
  value       = try(aws_dx_connection.primary[0].id, null)
}

output "secondary_dx_connection_id" {
  description = "Secondary Direct Connect connection ID when DX is enabled"
  value       = try(aws_dx_connection.secondary[0].id, null)
}

########################################
# SSM
########################################

output "ssm_endpoint_id" {
  description = "ID of the SSM VPC endpoint"
  value       = aws_vpc_endpoint.ssm.id
}