terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    # Configuration provided by Terragrunt
  }
}

provider "aws" {
  region = var.region
}

locals {
  common_tags = merge(
    var.tags,
    {
      repository_url  = var.repository_url
      repository_path = var.repository_path
      managed_by      = var.managed_by
      cost_center     = var.cost_center
      app_owner       = var.app_owner
      app_owner_email = var.app_owner_email
      creator_email   = var.creator_email
      tickets         = var.tickets
    }
  )
}

# Policy para EC2 (ejemplo: acceso básico a SSM, expansible)
resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.environment}_EC2BasicPolicy"
  description = "Policy básica para EC2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ssm:Describe*", "ec2:Describe*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = merge(local.common_tags, { Name = "${var.environment}_EC2BasicPolicy" })
}

# Role para EC2
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}_EC2Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, { Name = "${var.environment}_EC2Role" })
}

# Attach policy al role
resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Instance Profile para asignar al EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}_EC2Profile"
  role = aws_iam_role.ec2_role.name
}