resource "aws_customer_gateway" "on_prem" {
  for_each = local.customer_gateways

  type       = "ipsec.1"
  ip_address = each.value.public_ip
  bgp_asn    = each.value.bgp_asn

  tags = {
    Name = "${each.key}-customer-gateway"
  }
}

data "aws_vpn_gateway" "migration" {
  attached_vpc_id = aws_vpc.migration.id
}

resource "aws_vpn_connection" "on_prem" {
  for_each = aws_customer_gateway.on_prem

  type                = "ipsec.1"
  vpn_gateway_id      = data.aws_vpn_gateway.migration.id
  customer_gateway_id = each.value.id
  static_routes_only  = false

  tags = {
    Name = each.key
  }
}