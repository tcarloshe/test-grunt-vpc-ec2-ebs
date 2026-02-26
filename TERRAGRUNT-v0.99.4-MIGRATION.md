# Terragrunt v0.99.4 Migration Guide

Terragrunt v0.99.4 includes a CLI redesign. Here's the **working command syntax** with the latest best practices:

## Working Command Syntax

### Run-all Commands (for executing across all modules in a region)

Navigate to a region directory (e.g., `live/dev/eu-west-1`) and run:

```bash
# Plan all 4 modules (iam, vpc, ec2, ebs_orphan)
terragrunt run --all plan

# Apply all 4 modules
terragrunt run --all apply

# Destroy all modules
terragrunt run --all destroy

# Validate all modules
terragrunt run --all validate
```

### Selective Deployment (Filtering)

```bash
# Apply all except ebs_orphan (typical for initial deployment)
terragrunt run --all apply --filter '!./ebs_orphan'

# Apply only ebs_orphan
terragrunt run --all apply --filter './ebs_orphan'

# Apply only vpc and ec2
terragrunt run --all apply --filter './vpc' --filter './ec2'

# Validate all except ebs_orphan
terragrunt run --all validate --filter '!./ebs_orphan'
```

### Single Module Commands

From within a module directory (e.g., `live/dev/eu-west-1/vpc`):

```bash
terragrunt plan
terragrunt apply
terragrunt destroy
terragrunt validate
```

## Typical Deployment Workflow

```bash
# Navigate to a region directory
cd live/dev/eu-west-1

# Step 1: Plan everything
terragrunt run --all plan

# Step 2: Deploy infrastructure (excluding ebs_orphan initially)
terragrunt run --all apply --filter '!./ebs_orphan'

# Step 3: Verify infrastructure
aws ec2 describe-vpcs --region eu-west-1
aws ec2 describe-instances --region eu-west-1
aws iam list-instance-profiles

# Step 4: Deploy ebs_orphan when ready
terragrunt run --all apply --filter './ebs_orphan'

# Step 5: Destroy when done
terragrunt run --all destroy
```

## Using the Helper Script

For easier command execution, use the provided wrapper script:

```bash
# Make it executable
chmod +x terragrunt-wrapper.sh

# Plan all modules
./terragrunt-wrapper.sh plan-all

# Apply all modules
./terragrunt-wrapper.sh apply-all

# Destroy all modules with confirmation
./terragrunt-wrapper.sh destroy-all-confirm

# List all available commands
./terragrunt-wrapper.sh help
```

## Using Shell Aliases (Fastest!)

Source the aliases in your `~/.bashrc` or `~/.zshrc`:

```bash
source /home/tcarlos/grunt/test-grunt-vpc-ec2-ebs/terragrunt-aliases.sh
```

Then use shortcut commands from anywhere:

```bash
tg-plan-all          # Plan all modules
tg-apply-all         # Apply all modules
tg-destroy-all       # Destroy all (auto-approve)
tg-destroy-all-confirm # Destroy all (with confirmation)
tg-status            # Show deployment status
tg-help              # Show all available commands
```

## References

- [Terragrunt CLI Redesign Documentation](https://terragrunt.gruntwork.io/docs/migrate/cli-redesign/#use-the-new-run-command)
- [Run Command Documentation](https://terragrunt.gruntwork.io/docs/reference/cli-options/#run)
