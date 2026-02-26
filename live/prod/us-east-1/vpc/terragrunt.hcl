include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

inputs = {
  environment  = "prod"
  region       = "us-east-1"
  vpc_cidr     = "10.1.0.0/16"
  subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  
  tags = {
    environment   = "prod"
    created_by    = "Tom"
    creation_date = "2026-02-25"
    project       = "Terraform WorkShop"
  }
}
