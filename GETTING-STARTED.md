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
   cd live/dev/eu-west-1        # Navigate to a region
   terragrunt run --all init    # Initialize all 4 modules
   ```

4. **Validate Configuration**
   ```bash
   terragrunt run --all validate   # Check all modules
   ```

## Deployment

### Option A: Deploy All 4 Units
```bash
cd live/dev/eu-west-1

# Plan all infrastructure
terragrunt run --all plan

# Deploy everything
terragrunt run --all apply

# Verify deployment
aws ec2 describe-instances --region eu-west-1
```

### Option B: Deploy Selectively (Exclude ebs_orphan)
```bash
cd live/dev/eu-west-1

# Plan all except ebs_orphan (iam, vpc, ec2 only)
terragrunt run --all plan --filter '!./ebs_orphan'

# Deploy all except ebs_orphan
terragrunt run --all apply --filter '!./ebs_orphan'
```

### Option C: Deploy ebs_orphan Only
```bash
cd live/dev/eu-west-1

# Plan only ebs_orphan
terragrunt run --all plan --filter './ebs_orphan'

# Deploy only ebs_orphan
terragrunt run --all apply --filter './ebs_orphan'
```

### Option D: Module-by-Module (Manual Order)
```bash
cd live/dev/eu-west-1

# Deploy IAM first
cd iam && terragrunt apply
cd ../vpc && terragrunt apply
cd ../ec2 && terragrunt apply
cd ../ebs_orphan && terragrunt apply  # Optional
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
cd live/dev/eu-west-1/vpc && terragrunt output subnet_ids
cd ../iam && terragrunt output ec2_instance_profile
cd ../ec2 && terragrunt output ec2_id
```

### Clean Up
```bash
cd live/dev/eu-west-1

# Destroy all 4 modules
terragrunt run --all destroy

# Destroy all except ebs_orphan
terragrunt run --all destroy --filter '!./ebs_orphan'

# Destroy specific module
cd ./ec2 && terragrunt destroy
```

### Debug
```bash
# Get detailed logs
export TG_LOG_LEVEL=debug

# Validate syntax
cd live/dev/eu-west-1 && terragrunt run --all validate

# Validate specific modules only
terragrunt run --all validate --filter '!./ebs_orphan'
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
| Plan all | `cd live/dev/eu-west-1 && terragrunt run --all plan` |
| Apply all | `terragrunt run --all apply` |
| Apply (exclude ebs_orphan) | `terragrunt run --all apply --filter '!./ebs_orphan'` |
| Apply (only ebs_orphan) | `terragrunt run --all apply --filter './ebs_orphan'` |
| Destroy all | `terragrunt run --all destroy` |
| Plan single module | `cd live/dev/eu-west-1/vpc && terragrunt plan` |
| View outputs | `cd vpc && terragrunt output` |
| Validate all | `terragrunt run --all validate` |

- Check [README.md](README.md) for overview
- See [docs/STRUCTURE.md](docs/STRUCTURE.md) for architecture
- Review [QUICK-START.md](QUICK-START.md) for quick commands
- Visit [Terragrunt Docs](https://terragrunt.gruntwork.io/) official docs

---

**Status**: Ready to deploy!  
**Last Updated**: February 25, 2026  
**Note**: This is a getting-started guide; refer to documentation for advanced topics.
