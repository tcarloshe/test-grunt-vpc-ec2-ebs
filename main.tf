module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  tags     = var.tags
}

module "ec2" {
  source   = "./modules/ec2"
  tags     = var.tags
  subnet_ids = module.vpc.subnet_ids
  iam_instance_profile = module.iam.ec2_instance_profile
}

module "iam" {
  source   = "./modules/iam"
  tags     = var.tags
}