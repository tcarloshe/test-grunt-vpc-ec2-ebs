include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/iam"
}

inputs = {
  environment = "dev"
  region = "mx-central-1"
  
  tags = {
    environment   = "dev"
    created_by    = "Tom"
    creation_date = "2026-02-25"
    project       = "Terraform WorkShop"
    region        = "Mexico"
  }
}
