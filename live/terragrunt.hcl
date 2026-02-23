# Terragrunt root configuration for remote state
remote_state {
  backend = "s3"
  config = {
    bucket         = "tom-my-tf-state"
    key            = "root/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}


# Dummy terraform block to satisfy Terragrunt root config requirements
terraform {
  source = "./modules/empty"
}
