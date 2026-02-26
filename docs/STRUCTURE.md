# Terragrunt v0.99.4 Project Structure Guide

## Project Architecture

This project follows modern Terragrunt v0.99.4 and Terraform v1.9.8 best practices with a clear separation of concerns:

```
test-grunt-vpc-ec2-ebs/
├── live/                          # Environment configurations (Terragrunt workspaces)
│   ├── terragrunt.hcl            # Root configuration (remote state, providers)
│   ├── dev/                       # Development environment
│   │   ├── vpc/
│   │   │   ├── terragrunt.hcl    # VPC configuration & inputs
│   │   │   └── ...
│   │   ├── iam/
│   │   │   ├── terragrunt.hcl    # IAM configuration & inputs
│   │   │   └── ...
│   │   └── ec2/
│   │       ├── terragrunt.hcl    # EC2 configuration with dependencies
│   │       └── ...
│   └── staging/                  # (Future) Staging environment
│       ├── vpc/terragrunt.hcl
│       ├── iam/terragrunt.hcl
│       └── ec2/terragrunt.hcl
│
├── modules/                       # Reusable Terraform modules
│   ├── vpc/
│   │   ├── vpc.tf               # Main VPC resources
│   │   ├── variables.tf         # Module input variables
│   │   └── outputs.tf           # Module outputs
│   ├── iam/
│   │   ├── iam.tf               # IAM resources
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2/
│       ├── ec2.tf               # EC2 instances & EBS
│       ├── variables.tf
│       └── outputs.tf
│
├── docs/                         # Documentation
│   └── STRUCTURE.md             # This file
│
├── README.md                     # Project overview
├── TERRAGRUNT-v0.99.4-MIGRATION.md
├── QUICK-START.md
├── terragrunt-wrapper.sh        # Helper script
├── terragrunt-aliases.sh        # Shell aliases
└── .gitignore                    # Git ignore patterns
```

## Key Features

### 1. **Environment Separation**
- Each environment (dev, staging, prod) has its own directory
- Configurations are isolated and can be deployed independently
- `live/terragrunt.hcl` defines shared settings (backend, providers)

### 2. **Module Reusability**
- Modules in `modules/` are infrastructure-agnostic
- Each module is self-contained with variables and outputs
- Same modules can be deployed to different environments with different configurations

### 3. **Dependency Management** (Terragrunt Features)
- EC2 depends on VPC and IAM modules
- Terragrunt handles dependency ordering automatically
- Mock outputs allow planning when dependencies aren't applied yet

### 4. **Remote State Management**
- S3 backend configured in `live/terragrunt.hcl`
- DynamoDB table for state locking
- Terragrunt generates unique state keys per module

## Configuration Hierarchy

### Root Configuration (`live/terragrunt.hcl`)
```hcl
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
```

### Module Configuration (`live/dev/vpc/terragrunt.hcl`)
```hcl
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/vpc"
}

inputs = {
  region   = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  tags = {
    environment = "dev"
    project     = "Terraform WorkShop"
  }
}
```

## Working with Terragrunt v0.99.4

### Updated Command Syntax

Terragrunt v0.99.4 introduced breaking changes to the CLI interface:

| Operation | Old Syntax | New Syntax |
|-----------|-----------|-----------|
| Plan all | `terragrunt run-all plan` | `terragrunt run --all plan` |
| Apply all | `terragrunt run-all apply` | `terragrunt run --all apply` |
| Destroy all | `terragrunt run-all destroy` | `terragrunt run --all destroy` |
| Plan single | `terragrunt plan` | `terragrunt run -- plan` or `terragrunt plan` |

### Using Terragrunt

```bash
# Navigate to environment
cd live/dev

# Plan all modules in order
terragrunt run --all plan

# Apply all modules (with mock outputs)
terragrunt run --all apply --auto-approve

# Validate all modules
terragrunt run --all validate

# Destroy all modules
terragrunt run --all destroy --auto-approve

# Plan single module
cd vpc && terragrunt run -- plan
cd ../.. && terragrunt run -- plan --chdir vpc
```

### Using Wrapper Script

```bash
# Make executable (one-time)
chmod +x terragrunt-wrapper.sh

# Plan all
./terragrunt-wrapper.sh plan-all

# Apply all
./terragrunt-wrapper.sh apply-all

# Show help
./terragrunt-wrapper.sh help
```

## Backend Configuration

### S3 Backend Requirements

The project uses AWS S3 for remote state with the following setup:

```bash
# Create S3 bucket (if not exists)
aws s3api create-bucket \
  --bucket tom-my-tf-state \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket tom-my-tf-state \
  --versioning-configuration Status=Enabled

# Create DynamoDB table for locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

## Module Dependency Order

When running `terragrunt run --all`, modules are executed in this order:

1. **IAM** - Creates IAM roles and instance profiles (no dependencies)
2. **VPC** - Creates VPC and subnets (no dependencies)
3. **EC2** - Creates EC2 instances (depends on IAM and VPC)

### Dependency Declaration

```hcl
# EC2 module declares its dependencies
dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    subnet_ids = ["subnet-mock-1", "subnet-mock-2"]
  }
  skip_outputs = false
}

dependency "iam" {
  config_path = "../iam"
  
  mock_outputs = {
    ec2_instance_profile = "mock-profile"
  }
  skip_outputs = false
}
```

## Outputs and Data Flow

Each module exports outputs that can be consumed by dependents:

### VPC Outputs
```hcl
output "subnet_ids" {
  value = aws_subnet.private[*].id
}
```

### IAM Outputs
```hcl
output "ec2_instance_profile" {
  value = aws_iam_instance_profile.ec2.name
}
```

### EC2 Consumption
```hcl
inputs = merge(
  { ... },
  {
    subnet_ids           = dependency.vpc.outputs.subnet_ids
    iam_instance_profile = dependency.iam.outputs.ec2_instance_profile
  }
)
```

## Adding New Environments

To add a new environment (e.g., staging):

```bash
# Create staging directory structure
mkdir -p live/staging/{vpc,iam,ec2}

# Copy configuration from dev
cp live/dev/vpc/terragrunt.hcl live/staging/vpc/
cp live/dev/iam/terragrunt.hcl live/staging/iam/
cp live/dev/ec2/terragrunt.hcl live/staging/ec2/

# Update inputs in staging configs
# Example: live/staging/vpc/terragrunt.hcl
inputs = {
  region   = "us-east-1"
  vpc_cidr = "10.1.0.0/16"  # Different CIDR for staging
  tags = {
    environment = "staging"
  }
}
```

## Troubleshooting

### Issue: Cache Not Cleaned
```bash
# Manually clean terragrunt cache
find . -type d -name ".terragrunt-cache" -exec rm -rf {} +
find . -type f -name ".terraform.lock.hcl" -delete
```

### Issue: State Conflicts
```bash
# Force refresh of outputs
rm -rf live/dev/*/.terragrunt-cache
terragrunt run --all plan
```

### Issue: Dependency Outputs Missing
Use `mock_outputs` in dependency blocks to allow planning without all dependencies applied:

```hcl
dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    subnet_ids = ["subnet-mock-1", "subnet-mock-2"]
  }
}
```

## Version Information

- **Terragrunt**: v0.99.4
- **Terraform**: v1.9.8
- **AWS Provider**: ~> 5.0

## References

- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [Terragrunt CLI Redesign](https://terragrunt.gruntwork.io/docs/migrate/cli-redesign/)
- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
