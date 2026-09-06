terraform {
  backend "s3" {
    bucket       = "dmayrant-cloud-migration-tfstate"
    key          = "cloud-migration/account/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}