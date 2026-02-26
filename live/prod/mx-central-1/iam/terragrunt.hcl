include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/iam"
}

inputs = {
  environment = "prod"
  region = "mx-central-1"
  
  tags = {
    environment   = "prod"
    created_by    = "Tom"
    creation_date = "2026-02-25"
    project       = "Terraform WorkShop"
    region        = "Mexico"
  }
}
