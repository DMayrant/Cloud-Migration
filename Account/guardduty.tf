########################################
# GUARDDUTY DETECTOR
########################################

resource "aws_guardduty_detector" "guardduty_detector" {
  enable = true
}

########################################
# RUNTIME MONITORING
########################################

resource "aws_guardduty_detector_feature" "runtime_monitoring" {
  detector_id = aws_guardduty_detector.guardduty_detector.id

  name   = "RUNTIME_MONITORING"
  status = "ENABLED"

  additional_configuration {
    name   = "EC2_AGENT_MANAGEMENT"
    status = "ENABLED"
  }

  additional_configuration {
    name   = "ECS_FARGATE_AGENT_MANAGEMENT"
    status = "DISABLED"
  }

  additional_configuration {
    name   = "EKS_ADDON_MANAGEMENT"
    status = "DISABLED"
  }
}


########################################
# S3 PROTECTION
########################################

resource "aws_guardduty_detector_feature" "s3_protection" {
  detector_id = aws_guardduty_detector.guardduty_detector.id

  name   = "S3_DATA_EVENTS"
  status = "ENABLED"
}


########################################
# EBS MALWARE PROTECTION
########################################

resource "aws_guardduty_detector_feature" "malware_protection" {
  detector_id = aws_guardduty_detector.guardduty_detector.id

  name   = "EBS_MALWARE_PROTECTION"
  status = "ENABLED"
}