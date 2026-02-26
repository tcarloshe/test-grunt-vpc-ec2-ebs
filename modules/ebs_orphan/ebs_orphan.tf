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
  # Only owner and email tags for orphan volumes
  orphan_tags = {
    owner = var.owner
    email = var.email
  }
}

# Create 4 orphan EBS volumes (unattached)
resource "aws_ebs_volume" "orphan" {
  count = 4

  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  size              = var.volume_sizes[count.index]
  type              = "gp3"
  encrypted         = true

  tags = merge(
    local.orphan_tags,
    {
      Name = "${var.environment}_OrphanVolume${count.index + 1}"
    }
  )
}
