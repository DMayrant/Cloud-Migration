###############
# Migration VPC
###############

resource "aws_vpc" "migration" {
  cidr_block = "10.81.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "migration-vpc"
  }
}

####################
# Internet Gateway
####################

resource "aws_internet_gateway" "migration" {
  vpc_id = aws_vpc.migration.id

  tags = {
    Name = "migration-igw"
  }
}

#############################
# Public Subnet for NAT/ALB
#############################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.migration.id
  cidr_block              = "10.81.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "migration-public-subnet"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.migration.id
  cidr_block              = "10.81.10.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "migration-public-subnet-2"
    Environment = "production"
  }
}

#############################
# Private Subnet
#############################

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.migration.id
  cidr_block        = "10.81.40.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "migration-private-subnet"
  }
}

##############################
# Public Route Table
##############################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.migration.id

  tags = {
    Name = "migration-public-rt"
  }
}

##############################
# Public Route -> IGW
##############################

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.migration.id
}

##############################
# Public Subnet Association
##############################

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#####################################
# Second Public Subnet -> PUBLIC RT
#####################################

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}


##############################
# Private Route Table
##############################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.migration.id

  tags = {
    Name = "migration-private-rt"
  }
}

################
# Staging Subnet
################

resource "aws_subnet" "mgn_staging" {
  vpc_id            = aws_vpc.migration.id
  cidr_block        = "10.81.90.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "migration-staging-subnet"
  }
}


############################################################
# Associate Private Route Table with Staging Subnet
############################################################

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.mgn_staging.id
  route_table_id = aws_route_table.private.id
}

###############
# VPC Flow Logs
###############

resource "aws_flow_log" "vpc_flow_log_to_s3" {
  log_destination      = aws_s3_bucket.ssm_logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.migration.id
}

##############################
# Elastic IP for NAT Gateway
##############################

resource "aws_eip" "nat" {
  domain = "vpc"

  depends_on = [
    aws_internet_gateway.migration
  ]

  tags = {
    Name = "migration-nat-eip"
  }
}

################
# NAT Gateway
################

resource "aws_nat_gateway" "migration" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  depends_on = [
    aws_internet_gateway.migration
  ]

  tags = {
    Name = "migration-nat-gateway"
  }
}

##############################
# Private Route -> NAT Gateway
##############################

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.migration.id
}