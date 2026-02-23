include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules/iam"
}

inputs = {
  tags = {
    environment   = "dev"
    created_by    = "Tom"
    creation_date = "2026-02-22"
    project       = "Terraform WorkShop"
  }
}
