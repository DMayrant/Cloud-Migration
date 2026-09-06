########################################
# AWS Compute Optimizer 
########################################

resource "aws_computeoptimizer_enrollment_status" "organization" {
  status                  = "Active"
  include_member_accounts = true
}

########################################
# Compute Optimizer Recommendations 
# EC2
########################################

# resource "aws_computeoptimizer_recommendation_preferences" "ec2" {
#   resource_type = "Ec2Instance"

#   scope {
#     name  = "Organization"
#     value =  "ALL_ACCOUNTS"
#   }

#   enhanced_infrastructure_metrics = "Active"
# }