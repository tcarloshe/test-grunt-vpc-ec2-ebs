include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

inputs = {
  environment  = "dev"
  region       = "mx-central-1"
  vpc_cidr     = "10.0.0.0/16"
  subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  availability_zones = ["mx-central-1a", "mx-central-1b", "mx-central-1c"]
  
  tags = {
    environment   = "dev"
    created_by    = "Tom"
    creation_date = "2026-02-25"
    project       = "Terraform WorkShop"
    region        = "Mexico"
  }
}
