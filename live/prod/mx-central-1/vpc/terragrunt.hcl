include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

inputs = {
  environment  = "prod"
  region       = "mx-central-1"
  vpc_cidr     = "10.1.0.0/16"
  subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  availability_zones = ["mx-central-1a", "mx-central-1b", "mx-central-1c"]
  
  tags = {
    environment   = "prod"
    created_by    = "Tom"
    creation_date = "2026-02-25"
    project       = "Terraform WorkShop"
    region        = "Mexico"
  }
}
