# Cloud Migration ☁️

This project demonstrates a lift-and-shift migration using AWS Application Migration Service (MGN) to move legacy on-premises workloads into AWS while minimizing application changes.

The architecture uses redundant AWS Direct Connect connections for high-bandwidth, persistent migration traffic, with TCP 1500 used for MGN server replication. Direct Connect provisioning is feature-gated in the lab because physical connectivity is required.

AWS Organizations provides centralized governance, while GuardDuty, Security Hub, AWS Config, VPC Flow Logs, and Compute Optimizer support security, compliance, monitoring, and post-migration optimization.


# AWS Direct Connect Locations 🗺️
```bash 
aws directconnect describe-locations --region us-east-1 

aws directconnect describe-locations --region us-west-2 
```

[image alt](https://github.com/DMayrant/Cloud-Migration/blob/main/Cloud%20Migration.jpeg?raw=true)

# AWS Organizations 🗓️
```bash
aws organizations describe-organization \
  --query 'Organization.[Id,MasterAccountId,MasterAccountEmail]' \
  --output table

terraform import aws_organizations_organization.main <organization-Id>

aws organizations describe-organization \
  --query 'Organization.Id' \
  --output text  

 terraform state show aws_organizations_organization.main  
  ```

# Terraform Commands 🏗️
```bash 
terraform init
terraform fmt -recursive 
terraform validate 
terraform plan 
terraform apply
```
