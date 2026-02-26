# Quick Start Guide: Terragrunt v0.99.4

## Installation Complete ✓

Your Terragrunt infrastructure has been updated to support v0.99.4. Here's how to use it:

## Quick Commands

### From the `live/dev` directory:

```bash
# Plan all infrastructure
terragrunt run -- run-all plan

# Apply all infrastructure (auto-approve)
terragrunt run -- run-all apply --auto-approve

# Destroy all infrastructure (auto-approve)
terragrunt run -- run-all destroy --auto-approve

# Validate all modules
terragrunt run -- run-all validate
```

### From individual module directories (e.g., `live/dev/vpc`):

```bash
# Plan this module only
terragrunt run -- plan

# Apply this module
terragrunt run -- apply --auto-approve

# Destroy this module
terragrunt run -- destroy --auto-approve
```

## Using the Wrapper Script (Easier!)

```bash
# Make it executable (one-time)
chmod +x terragrunt-wrapper.sh

# Then from anywhere in the live tree:
./terragrunt-wrapper.sh plan-all
./terragrunt-wrapper.sh apply-all
./terragrunt-wrapper.sh destroy-all
./terragrunt-wrapper.sh destroy-all-confirm  # Ask before destroying
```

## Using Shell Aliases (Easiest!)

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
source /home/tcarlos/grunt/test-grunt-vpc-ec2-ebs/terragrunt-aliases.sh
```

Then use:
```bash
tg-plan-all
tg-apply-all
tg-destroy-all-confirm
tg-status
tg-help
```

## Key Changes from Old Syntax

| Old | New |
|-----|-----|
| `terragrunt run-all plan` | `terragrunt run -- run-all plan` |
| `terragrunt run-all apply` | `terragrunt run -- run-all apply` |
| `terragrunt run-all destroy` | `terragrunt run -- run-all destroy` |

## Your Infrastructure

Your Terragrunt setup includes:
- **VPC Module** (`live/dev/vpc/`) - AWS VPC with subnets
- **IAM Module** (`live/dev/iam/`) - IAM roles and policies
- **EC2 Module** (`live/dev/ec2/`) - EC2 instances with EBS volumes

The EC2 module depends on both VPC and IAM, so apply order is automatic.

## Troubleshooting

If you get "command not found" errors:

```bash
# Update your ~/.bashrc or ~/.zshrc to source the aliases:
echo 'source /home/tcarlos/grunt/test-grunt-vpc-ec2-ebs/terragrunt-aliases.sh' >> ~/.bashrc
source ~/.bashrc

# Or use the full path:
cd /home/tcarlos/grunt/test-grunt-vpc-ec2-ebs/live/dev
terragrunt run -- run-all plan
```

## Documentation

- [Full Migration Guide](./TERRAGRUNT-v0.99.4-MIGRATION.md)
- [Official Terragrunt Docs](https://terragrunt.gruntwork.io/docs/migrate/cli-redesign/)
