########################################
# DIRECT CONNECT GATEWAY
########################################

resource "aws_dx_gateway" "migration" {
  name            = "migration-dx-gateway"
  amazon_side_asn = 64512

  tags = {
    Name = "migration-dx-gateway"
  }
}

########################################
# VIRTUAL PRIVATE GATEWAY
########################################

resource "aws_vpn_gateway" "migration" {
  vpc_id = aws_vpc.migration.id

  tags = {
    Name = "migration-vgw"
  }
}

########################################
# DX GATEWAY -> VGW ASSOCIATION
########################################

resource "aws_dx_gateway_association" "migration" {
  dx_gateway_id         = aws_dx_gateway.migration.id
  associated_gateway_id = aws_vpn_gateway.migration.id

  allowed_prefixes = [
    var.vpc_cidr
  ]
}

########################################
# PRIMARY DIRECT CONNECT
########################################

resource "aws_dx_connection" "primary" {
  count = var.enable_direct_connect ? 1 : 0

  name      = "migration-dx-primary"
  bandwidth = "1Gbps"
  location  = var.dx_primary_location

  tags = {
    Name = "migration-dx-primary"
  }
}

########################################
# PRIMARY PRIVATE VIF
########################################

resource "aws_dx_private_virtual_interface" "primary" {
  count = var.enable_direct_connect ? 1 : 0

  connection_id = aws_dx_connection.primary[count.index].id

  name           = "migration-private-vif-primary"
  vlan           = var.dx_primary_vlan
  address_family = "ipv4"
  bgp_asn        = var.on_prem_bgp_asn

  dx_gateway_id = aws_dx_gateway.migration.id

  tags = {
    Name = "migration-private-vif-primary"
  }
}

########################################
# SECONDARY DIRECT CONNECT
########################################

resource "aws_dx_connection" "secondary" {
  count = var.enable_direct_connect ? 1 : 0

  name      = "migration-dx-secondary"
  bandwidth = "1Gbps"
  location  = var.dx_secondary_location

  tags = {
    Name = "migration-dx-secondary"
  }
}

########################################
# SECONDARY PRIVATE VIF
########################################

resource "aws_dx_private_virtual_interface" "secondary" {
  count = var.enable_direct_connect ? 1 : 0

  connection_id = aws_dx_connection.secondary[count.index].id

  name           = "migration-private-vif-secondary"
  vlan           = var.dx_secondary_vlan
  address_family = "ipv4"
  bgp_asn        = var.on_prem_bgp_asn

  dx_gateway_id = aws_dx_gateway.migration.id

  tags = {
    Name = "migration-private-vif-secondary"
  }
}