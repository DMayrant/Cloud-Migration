########################################
# AWS SECURITY HUB
########################################

resource "aws_securityhub_account" "main" {
  enable_default_standards = false

  lifecycle {
    prevent_destroy = true
  }
}

########################################
# AWS FOUNDATIONAL SECURITY
# BEST PRACTICES
########################################

resource "aws_securityhub_standards_subscription" "aws_foundational" {
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"

  depends_on = [
    aws_securityhub_account.main
  ]
}


########################################
# CIS AWS FOUNDATIONS BENCHMARK
########################################

resource "aws_securityhub_standards_subscription" "cis" {
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/1.4.0"

  depends_on = [
    aws_securityhub_account.main
  ]
}