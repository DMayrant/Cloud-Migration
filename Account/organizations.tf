########################################
# AWS ORGANIZATIONS
########################################

resource "aws_organizations_organization" "main" {
  feature_set = "ALL"

  aws_service_access_principals = [
    "compute-optimizer.amazonaws.com",
    "securityhub.amazonaws.com",
    "guardduty.amazonaws.com",
    "config.amazonaws.com"
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"

  ]

  lifecycle {
    prevent_destroy = true # Prevents Accidental Deletion of AWS Organizations
  }
}


########################################
# SECURITY OU
########################################

resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organization.main.roots[0].id
}


########################################
# WORKLOADS OU
########################################

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.main.roots[0].id
}


########################################
# PRODUCTION OU
########################################

resource "aws_organizations_organizational_unit" "production" {
  name      = "Production"
  parent_id = aws_organizations_organizational_unit.workloads.id
}


########################################
# SCP - DENY DISABLING CLOUDTRAIL
########################################

resource "aws_organizations_policy" "protect_cloudtrail" {
  name        = "ProtectCloudTrail"
  description = "Prevent member accounts from disabling or deleting CloudTrail"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "DenyCloudTrailDisable"
        Effect = "Deny"

        Action = [
          "cloudtrail:StopLogging",
          "cloudtrail:DeleteTrail"
        ]

        Resource = "*"
      }
    ]
  })
}


########################################
# ATTACH CLOUDTRAIL SCP TO PRODUCTION
########################################

resource "aws_organizations_policy_attachment" "protect_cloudtrail" {
  policy_id = aws_organizations_policy.protect_cloudtrail.id
  target_id = aws_organizations_organizational_unit.production.id
}


########################################
# SCP - PROTECT SECURITY SERVICES
########################################

resource "aws_organizations_policy" "protect_security_services" {
  name        = "ProtectSecurityServices"
  description = "Prevent member accounts from disabling core security services"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ProtectSecurityServices"
        Effect = "Deny"

        Action = [
          "guardduty:DeleteDetector",
          "guardduty:DisassociateFromAdministratorAccount",
          "securityhub:DisableSecurityHub"
        ]

        Resource = "*"
      }
    ]
  })
}


########################################
# ATTACH SECURITY SCP TO PRODUCTION
########################################

resource "aws_organizations_policy_attachment" "protect_security_services" {
  policy_id = aws_organizations_policy.protect_security_services.id
  target_id = aws_organizations_organizational_unit.production.id
}