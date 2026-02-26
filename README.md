# Terraform AWS Workshop - VPC, IAM, EC2

A modern infrastructure-as-code project using **Terragrunt v0.99.4** and **Terraform v1.9.8** to deploy AWS infrastructure with VPC, IAM roles, and EC2 instances.

## Quick Start

### Prerequisites

- AWS CLI configured with credentials
- Terragrunt v0.99.4 installed
- Terraform v1.9.8 installed
- S3 bucket for state management (`tom-my-tf-state`)
- DynamoDB table for state locking (`terraform-locks`)

### Deploy Infrastructure

```bash
# Navigate to a region (e.g., dev/eu-west-1)
cd live/dev/eu-west-1

# Review planned changes for all 4 modules
terragrunt run --all plan

# Deploy all infrastructure
terragrunt run --all apply

# Or deploy excluding ebs_orphan (typical for initial deployment)
terragrunt run --all apply --filter '!./ebs_orphan'

# Later, deploy only ebs_orphan
terragrunt run --all apply --filter './ebs_orphan'

# Validate configuration
terragrunt run --all validate

# Destroy when done
terragrunt run --all destroy
```

### Using Helper Scripts

```bash
# Plan all modules
./terragrunt-wrapper.sh plan-all

# Apply all modules
./terragrunt-wrapper.sh apply-all

# Destroy all modules with confirmation
./terragrunt-wrapper.sh destroy-all-confirm

# View all available commands
./terragrunt-wrapper.sh help
```

## Project Structure

```
live/                    # Environment configurations
├── terragrunt.hcl      # Root config (remote state, backend)
├── dev/                # Development environment
│   ├── vpc/            # VPC module configuration
│   ├── iam/            # IAM module configuration
│   └── ec2/            # EC2 module configuration
└── staging/            # (Future) Staging environment

modules/               # Reusable Terraform modules
├── vpc/               # VPC with subnets
├── iam/               # IAM roles & policies
└── ec2/               # EC2 instances with EBS volumes
```

**Full documentation**: See [docs/STRUCTURE.md](docs/STRUCTURE.md)

## Infrastructure Components

### Key Features

- **VPC Module**: Creates VPC with CIDR block `10.0.0.0/16` with private subnets across multiple AZs
- **IAM Module**: Creates EC2 instance profiles and IAM roles for secure instance access
- **EC2 Module**: Deploys t2.micro instances with multiple EBS volumes for storage
- **Dependency Management**: Terragrunt automatically handles deployment order (IAM → VPC → EC2)
- **Remote State**: S3 backend with DynamoDB locking for team collaboration
- **Tagging Strategy**: Consistent tags across all resources (environment, project, created_by, creation_date)

## Versions

| Component | Version |
|-----------|---------|
| Terragrunt | v0.99.4 |
| Terraform | v1.9.8 |
| AWS Provider | ~> 5.0 |
| AWS Region | us-east-1 |

## Common Commands

### Deployment

```bash
# Plan all modules in environment
cd live/dev
terragrunt run --all plan

# Apply all modules
terragrunt run --all apply --auto-approve

# Destroy all modules
terragrunt run --all destroy --auto-approve
```

### Module-Specific Operations

```bash
# Plan only VPC
cd live/dev/eu-west-1/vpc
terragrunt plan

# Apply only IAM
cd ../iam
terragrunt apply

# Check outputs
terragrunt output
```

### Debugging

```bash
# Validate configuration
cd live/dev/eu-west-1
terragrunt run --all validate

# Validate excluding ebs_orphan
terragrunt run --all validate --filter '!./ebs_orphan'

# Show current status
./terragrunt-wrapper.sh status

# Clean cache and lock files
find . -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null
find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null
```

## Documentation

- [Project Structure & Architecture](docs/STRUCTURE.md) - Detailed guide on project layout and best practices
- [Migration Guide](TERRAGRUNT-v0.99.4-MIGRATION.md) - Upgrading from older Terragrunt versions
- [Quick Reference](QUICK-START.md) - Common commands and workflows

## Troubleshooting

### Issue: Cache Not Cleaned
```bash
find . -type d -name ".terragrunt-cache" -exec rm -rf {} +
```

### Issue: State Conflicts
```bash
rm -rf live/dev/*/.terragrunt-cache
terragrunt run --all plan
```

### Issue: Dependency Outputs Missing
Dependency blocks include `mock_outputs` to allow planning without all dependencies applied:
```hcl
dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    subnet_ids = ["subnet-mock-1", "subnet-mock-2"]
  }
}
```

## Recent Updates

### February 25, 2026 - v0.99.4 Migration

✅ **Completed**:
- Updated CLI commands to new syntax (`terragrunt run --all` instead of `terragrunt run-all`)
- Restructured project to modern Terragrunt best practices
- Removed root-level Terraform files (no longer needed in Terragrunt projects)
- Cleaned up all cache and state artifacts
- Added comprehensive documentation and guides
- Created helper scripts and shell aliases for easier operations

## Support

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/)

---

**Last Updated**: February 25, 2026  
**Status**: ✅ Production Ready (Terragrunt v0.99.4 + Terraform v1.9.8)
