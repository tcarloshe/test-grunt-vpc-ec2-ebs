# Getting Started Checklist

Use this checklist to quickly get the project up and running.

## Pre-Deployment Setup

- [ ] **AWS Account Access**
  - [ ] AWS credentials configured: `aws sts get-caller-identity`
  - [ ] Permissions for EC2, VPC, IAM, S3, DynamoDB

- [ ] **Tools Installed**
  - [ ] Terragrunt v0.99.4: `terragrunt -v`
  - [ ] Terraform v1.9.8: `terraform -v`
  - [ ] AWS CLI: `aws --version`

- [ ] **Backend Resources**
  - [ ] S3 bucket exists: `tom-my-tf-state`
  - [ ] DynamoDB table exists: `terraform-locks`
  - [ ] Correct region: `us-east-1`

## First-Time Setup

1. **Clone/Navigate to Project**
   ```bash
   cd test-grunt-vpc-ec2-ebs
   ```

2. **Review Documentation**
   ```bash
   cat README.md                    # Project overview
   cat QUICK-START.md              # Quick commands
   cat docs/STRUCTURE.md           # Architecture details
   ```

3. **Initialize Terragrunt**
   ```bash
   cd live/dev
   terragrunt init              # Initialize all modules
   ```

4. **Validate Configuration**
   ```bash
   terragrunt run --all validate   # Check all modules
   ```

## Deployment

### Option A: Simple Auto-Approve
```bash
# Plan all infrastructure
terragrunt run --all plan

# Deploy everything (no confirmation)
terragrunt run --all apply --auto-approve

# Verify deployment
aws ec2 describe-instances --region us-east-1
```

### Option B: Review Before Applying
```bash
# Plan all infrastructure
terragrunt run --all plan > deployment.plan

# Review the plan file
cat deployment.plan

# Deploy with confirmation
terragrunt run --all apply
# Type 'yes' to confirm
```

### Option C: Module-by-Module
```bash
# Deploy IAM first
cd vpc && terragrunt run -- apply --auto-approve
cd ../iam && terragrunt run -- apply --auto-approve
cd ../ec2 && terragrunt run -- apply --auto-approve
```

## Verification

After deployment:

```bash
# Check module states
cd tc/vpc && terragrunt run -- output

# AWS Console verification
aws ec2 describe-vpcs --region us-east-1
aws ec2 describe-instances --region us-east-1
aws ec2 describe-volumes --region us-east-1
aws iam list-instance-profiles

# View state in S3
aws s3 ls s3://tom-my-tf-state --recursive
```

## Useful Commands

### View Outputs
```bash
cd live/dev/vpc && terragrunt run -- output subnet_ids
cd ../iam && terragrunt run -- output ec2_instance_profile
cd ../ec2 && terragrunt run -- output ec2_id
```

### Clean Up
```bash
# Destroy all (with confirmation)
terragrunt run --all destroy

# Destroy specific module
cd live/dev/ec2 && terragrunt run -- destroy --auto-approve
```

### Debug
```bash
# Get detailed logs
export TG_LOG_LEVEL=debug

# Validate syntax
terragrunt run --all validate

# Check what would be executed (dry-run)
terragrunt run --all --dry-run plan
```

## Helper Script Usage

```bash
# Make scripts executable (first time only)
chmod +x terragrunt-wrapper.sh

# Available commands
./terragrunt-wrapper.sh plan-all          # Plan all modules
./terragrunt-wrapper.sh apply-all         # Apply with auto-approve
./terragrunt-wrapper.sh destroy-all       # Destroy with auto-approve
./terragrunt-wrapper.sh destroy-all-confirm # Destroy with confirmation
./terragrunt-wrapper.sh validate-all      # Validate all
./terragrunt-wrapper.sh status            # Show current status
./terragrunt-wrapper.sh help              # Show all commands
```

## Shell Aliases (Optional)

Source the aliases file for quick commands:

```bash
# Add to ~/.bashrc or ~/.zshrc
source /path/to/test-grunt-vpc-ec2-ebs/terragrunt-aliases.sh

# Then use
tg-plan-all
tg-apply-all
tg-destroy-all-confirm
tg-status
```

## Troubleshooting

### Issue: "terraform: command not found"
```bash
which terraform
terraform -v
# If not found, install: https://www.terraform.io/downloads.html
```

### Issue: "terragrunt: command not found"
```bash
snap install terragrunt  # or from releases: https://github.com/gruntwork-io/terragrunt/releases
terragrunt -v
```

### Issue: AWS credentials not found
```bash
aws configure
# Or set environment variables:
export AWS_ACCESS_KEY_ID="xxxxx"
export AWS_SECRET_ACCESS_KEY="xxxxx"
export AWS_DEFAULT_REGION="us-east-1"
```

### Issue: S3 bucket or DynamoDB table not found
```bash
# Create S3 bucket
aws s3api create-bucket --bucket tom-my-tf-state --region us-east-1
aws s3api put-bucket-versioning --bucket tom-my-tf-state --versioning-configuration Status=Enabled

# Create DynamoDB table
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### Issue: Cache corruption or strange errors
```bash
# Clean all caches
find . -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null
find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null

# Re-run commands
terragrunt run --all plan
```

## Post-Deployment

### Connection to EC2 Instance
```bash
# Get instance details
INSTANCE_ID=$(aws ec2 describe-instances --query 'Reservations[0].Instances[0].InstanceId' --output text)

# Get security group
SG=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].SecurityGroups[0].GroupId' --output text)

# Allow SSH (configure your IP)
aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port 22 --cidr YOUR_IP/32
```

### Monitor Resources
```bash
# Watch EC2 instances
watch -n 5 'aws ec2 describe-instances --query "Reservations[].Instances[].[InstanceId,State.Name,PrivateIpAddress]" --output table'

# Monitor volumes
aws ec2 describe-volumes --query 'Volumes[].[VolumeId,Size,State,Tags[0].Value]' --output table
```

## Important Reminders

- ⚠️ **Never commit credentials**: Use AWS IAM, environment variables, or profiles
- ⚠️ **Always review plans**: Use `terraform plan` before applying
- ⚠️ **State file is critical**: Keep backups of terraform state
- ⚠️ **Cost management**: Monitor AWS spending, especially EC2 and storage
- ✅ **Use tags**: Helps with cost tracking and resource management

## Quick Reference

| Task | Command |
|------|---------|
| Plan all | `terragrunt run --all plan` |
| Apply all | `terragrunt run --all apply --auto-approve` |
| Destroy all | `terragrunt run --all destroy --auto-approve` |
| Plan VPC | `cd live/dev/vpc && terragrunt run -- plan` |
| View outputs | `terragrunt run -- output` |
| Validate | `terragrunt run --all validate` |
| Check status | `./terragrunt-wrapper.sh status` |
| View help | `./terragrunt-wrapper.sh help` |

## Support

- Check [README.md](README.md) for overview
- See [docs/STRUCTURE.md](docs/STRUCTURE.md) for architecture
- Review [QUICK-START.md](QUICK-START.md) for quick commands
- Visit [Terragrunt Docs](https://terragrunt.gruntwork.io/) official docs

---

**Status**: Ready to deploy!  
**Last Updated**: February 25, 2026  
**Note**: This is a getting-started guide; refer to documentation for advanced topics.
