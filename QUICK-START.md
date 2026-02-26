# Quick Start Guide: Terragrunt v0.99.4

## Installation Complete ✓

Your Terragrunt infrastructure has been updated to support v0.99.4. Here's how to use it:

## Quick Commands

### From a region directory (e.g., `live/dev/eu-west-1`):

```bash
# Plan all 4 units (iam, vpc, ec2, ebs_orphan)
terragrunt run --all plan

# Apply all 4 units
terragrunt run --all apply

# Destroy all infrastructure
terragrunt run --all destroy

# Validate all modules
terragrunt run --all validate
```

### Selective Deployment with Filters

```bash
# Apply all except ebs_orphan (deploy iam, vpc, ec2)
terragrunt run --all apply --filter '!./ebs_orphan'

# Apply only ebs_orphan
terragrunt run --all apply --filter './ebs_orphan'

# Apply only vpc and ec2
terragrunt run --all apply --filter './vpc' --filter './ec2'
```

### From individual module directories (e.g., `live/dev/eu-west-1/vpc`):

```bash
# Plan this module only
terragrunt plan

# Apply this module
terragrunt apply

# Destroy this module
terragrunt destroy
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

## Usage Pattern

The recommended workflow is:

1. **Navigate to a region directory**: `cd /home/tcarlos/grunt/test-grunt-vpc-ec2-ebs/live/dev/eu-west-1`
2. **Plan changes**: `terragrunt run --all plan`
3. **Apply with selective filters** (if needed): `terragrunt run --all apply --filter '!./ebs_orphan'`
4. **Deploy specific units later**: `terragrunt run --all apply --filter './ebs_orphan'`
5. **Destroy when done**: `terragrunt run --all destroy`

## Your Infrastructure

Your Terragrunt setup includes 4 modules per region:
- **IAM Module** (`./iam/`) - IAM roles and policies
- **VPC Module** (`./vpc/`) - AWS VPC with subnets
- **EC2 Module** (`./ec2/`) - EC2 instances with EBS volumes
- **EBS Orphan Module** (`./ebs_orphan/`) - Orphaned EBS volumes

The EC2 module depends on both VPC and IAM, so apply order is automatic. You can exclude ebs_orphan if not needed.

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
