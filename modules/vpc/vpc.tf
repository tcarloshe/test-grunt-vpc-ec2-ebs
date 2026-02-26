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

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(local.common_tags, { Name = "${var.environment}_MainVPC" })
}

resource "aws_subnet" "private" {
  count = length(var.subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false # Privadas

  tags = merge(local.common_tags, { Name = "${var.environment}_PrivateSubnet${count.index + 1}" })
}