data "aws_vpc_endpoint_service" "mgn" {
  service      = "mgn"
  service_type = "Interface"
}
