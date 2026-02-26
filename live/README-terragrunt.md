# Terragrunt Deployment Guide

## Project Structure

```
live/
├── root.hcl                      # Root configuration for remote state
├── dev/                          # Development environment
│   ├── eu-west-1/               # EU region
│   │   ├── iam/terragrunt.hcl
│   │   ├── vpc/terragrunt.hcl
│   │   ├── ec2/terragrunt.hcl
│   │   └── ebs_orphan/terragrunt.hcl
│   ├── us-east-1/               # US-East region
│   └── [other regions...]
└── prod/                         # Production environment
    ├── us-east-1/               # Production regions
    └── [other regions...]
```

## Quick Deployment

1. **Navigate to a region directory**:
   ```bash
   cd live/dev/eu-west-1
   ```

2. **Plan all infrastructure**:
   ```bash
   terragrunt run --all plan
   ```

3. **Deploy infrastructure** (choose one):
   ```bash
   # Option A: Deploy all 4 units
   terragrunt run --all apply

   # Option B: Deploy all except ebs_orphan (typical first deployment)
   terragrunt run --all apply --filter '!./ebs_orphan'
   ```

4. **Deploy ebs_orphan later** (if deferred):
   ```bash
   terragrunt run --all apply --filter './ebs_orphan'
   ```

5. **Destroy when done**:
   ```bash
   terragrunt run --all destroy
   ```

## Advanced Filtering

```bash
# Deploy only specific modules
terragrunt run --all apply --filter './vpc'
terragrunt run --all apply --filter './iam'
terragrunt run --all apply --filter './ec2'
terragrunt run --all apply --filter './ebs_orphan'

# Deploy multiple specific modules
terragrunt run --all apply --filter './vpc' --filter './ec2'

# Plan all except ebs_orphan
terragrunt run --all plan --filter '!./ebs_orphan'
```

## Single Module Operations

Navigate to the module directory and run commands directly:

```bash
cd live/dev/eu-west-1/vpc
terragrunt init
terragrunt plan
terragrunt apply
terragrunt destroy
```

## Module Details

### VPC Module (`vpc/terragrunt.hcl`)
- VPC with subnets
- Input variables: `vpc_cidr_block`, `availability_zones`
- Output: `vpc_id`, `subnet_ids`

### IAM Module (`iam/terragrunt.hcl`)
- EC2 instance profiles and IAM roles
- Input variables: `role_name`, `policies`
- Output: `instance_profile_arn`, `role_id`

### EC2 Module (`ec2/terragrunt.hcl`)
- EC2 instances with EBS volumes
- Depends on: VPC and IAM modules
- Input variables: `instance_type`, `key_name`
- Output: `instance_ids`, `private_ips`

### EBS Orphan Module (`ebs_orphan/terragrunt.hcl`)
- Orphaned EBS volumes management
- Optional module (can be deployed separately)

## Notes

- All Terraform code remains in the `modules/` directory
- Each region has its own set of 4 modules
- Dependency management is automatic (IAM → VPC → EC2)
- Remote state is managed centrally in `root.hcl`
- You can deploy different modules in different regions independently

## Documentation

- [Quick Start Guide](../QUICK-START.md)
- [Getting Started](../GETTING-STARTED.md)
- [Migration Guide](../TERRAGRUNT-v0.99.4-MIGRATION.md)
- [Architecture](../docs/STRUCTURE.md)
