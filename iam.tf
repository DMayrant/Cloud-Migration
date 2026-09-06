########################################
# MGN REPLICATION SERVER ROLE
########################################

resource "aws_iam_role" "mgn_replication_server" {
  name = "AWSApplicationMigrationReplicationServerRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "mgn_replication_server" {
  role = aws_iam_role.mgn_replication_server.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSApplicationMigrationReplicationServerPolicy"
}


########################################
# MGN CONVERSION SERVER ROLE
########################################

resource "aws_iam_role" "mgn_conversion_server" {
  name = "AWSApplicationMigrationConversionServerRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "mgn_conversion_server" {
  role = aws_iam_role.mgn_conversion_server.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSApplicationMigrationConversionServerPolicy"
}


########################################
# MGN TEST / CUTOVER INSTANCE ROLE
########################################

resource "aws_iam_role" "mgn_ec2" {
  name = "migration-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "migration-ec2-ssm-role"
    Environment = "migration"
  }
}


########################################
# SSM ACCESS
########################################

resource "aws_iam_role_policy_attachment" "mgn_ec2_ssm" {
  role = aws_iam_role.mgn_ec2.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


########################################
# EC2 INSTANCE PROFILE
########################################

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "migration-ec2-profile"
  role = aws_iam_role.mgn_ec2.name
}


########################################
# MGN AGENT INSTALLATION
########################################

resource "aws_iam_user_policy_attachment" "mgn_agent_installation" {
  user = var.mgn_installation_user

  policy_arn = "arn:aws:iam::aws:policy/AWSApplicationMigrationAgentInstallationPolicy"
}


########################################
# MGN AGENT IAM POLICY SIMULATION
########################################

data "aws_iam_principal_policy_simulation" "mgn_agent_permissions" {
  policy_source_arn = "arn:aws:iam::${var.aws_account_id}:user/${var.mgn_installation_user}"

  action_names = [
    "mgn:GetAgentInstallationAssetsForMgn",
    "mgn:SendAgentMetricsForMgn",
    "mgn:SendAgentLogsForMgn"
  ]

  depends_on = [
    aws_iam_user_policy_attachment.mgn_agent_installation
  ]
}