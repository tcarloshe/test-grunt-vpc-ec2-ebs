# This is the root Terragrunt configuration for the entire infrastructure
# It defines remote state configuration that is inherited by all child modules
# Note: In Terragrunt v0.99.4+, only remote_state is needed at the root level

remote_state {
  backend = "s3"
  config = {
    bucket         = "tom-my-tf-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
