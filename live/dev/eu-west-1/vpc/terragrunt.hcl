include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

inputs = {
  environment  = "dev"
  region       = "eu-west-1"
  vpc_cidr     = "10.0.0.0/16"
  subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["eu-west-1a", "eu-west-1b"]
  
  tags = {
    environment   = "dev"
    created_by    = "Tom"
    creation_date = "2026-02-25"
    project       = "Terraform WorkShop"
    region        = "EU Ireland"
  }
}
