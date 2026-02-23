# Terragrunt Migration Guide

## Structure

- `live/terragrunt.hcl`: Root configuration for remote state.
- `live/dev/vpc/terragrunt.hcl`: VPC module configuration.
- `live/dev/ec2/terragrunt.hcl`: EC2 module configuration.
- `live/dev/iam/terragrunt.hcl`: IAM module configuration.

## Usage

1. Install Terragrunt: https://terragrunt.gruntwork.io/docs/getting-started/install/
2. Navigate to a module directory, e.g.:
   cd live/dev/vpc
3. Run:
   terragrunt init
   terragrunt plan
   terragrunt apply

Repeat for each module (vpc, ec2, iam) as needed.

## Notes
- All Terraform code remains in the `modules/` directory.
- Inputs are now provided via each module's `terragrunt.hcl`.
- Remote state is managed centrally in the root `terragrunt.hcl`.
