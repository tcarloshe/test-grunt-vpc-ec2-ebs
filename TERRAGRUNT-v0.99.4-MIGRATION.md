# Terragrunt v0.99.4 Migration Guide

Terragrunt v0.99.4 includes a CLI redesign. Here are the key command changes:

## New Command Syntax

### Run-all Commands (for executing across all modules)

| Operation | Old Syntax | New Syntax |
|-----------|-----------|-----------|
| Plan all | `terragrunt run-all plan` | `terragrunt run -- run-all plan` |
| Apply all | `terragrunt run-all apply` | `terragrunt run -- run-all apply` |
| Destroy all | `terragrunt run-all destroy` | `terragrunt run -- run-all destroy` |
| Validate all | `terragrunt run-all validate` | `terragrunt run -- run-all validate` |

### Single Module Commands

| Operation | Old Syntax | New Syntax |
|-----------|-----------|-----------|
| Plan | `terragrunt plan` | `terragrunt run -- plan` or `terragrunt plan` |
| Apply | `terragrunt apply` | `terragrunt run -- apply` or `terragrunt apply` |
| Destroy | `terragrunt destroy` | `terragrunt run -- destroy` or `terragrunt destroy` |
| Validate | `terragrunt validate` | `terragrunt run -- validate` or `terragrunt validate` |

**Note**: Single module commands may still work with the old syntax for backwards compatibility, but the new syntax is preferred.

## Usage Examples

Navigate to the `live/dev` directory and run:

```bash
# Plan all modules (VPC, IAM, EC2)
terragrunt run -- run-all plan

# Apply all modules with auto-approval
terragrunt run -- run-all apply --auto-approve

# Destroy all modules
terragrunt run -- run-all destroy --auto-approve

# Plan only specific module (from live/dev directory)
cd vpc && terragrunt run -- plan
```

## Using the Helper Script

For easier command execution, use the provided `tg` wrapper script:

```bash
# Make it executable
chmod +x terragrunt-wrapper.sh

# Plan all modules
./terragrunt-wrapper.sh plan-all

# Apply all modules
./terragrunt-wrapper.sh apply-all

# List all available shortcuts
./terragrunt-wrapper.sh help
```

## References

- [Terragrunt CLI Redesign Documentation](https://terragrunt.gruntwork.io/docs/migrate/cli-redesign/#use-the-new-run-command)
- [Run Command Documentation](https://terragrunt.gruntwork.io/docs/reference/cli-options/#run)
