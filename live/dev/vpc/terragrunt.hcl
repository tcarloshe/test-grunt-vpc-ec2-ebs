include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/vpc"
}

inputs = {
  vpc_cidr = "10.0.0.0/16"
  tags     = {
    environment   = "dev"
    created_by    = "Tom"
    creation_date = "2026-02-22"
    project       = "Terraform WorkShop"
  }
}
