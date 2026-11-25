locals {
  customer_gateways = {
    "vpn-a" = var.vpn_a_customer_gateway
    "vpn-b" = var.vpn_b_customer_gateway
  }
}