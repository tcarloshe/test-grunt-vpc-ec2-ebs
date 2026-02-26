include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/ebs_orphan"
}

# Dependencies on IAM and VPC modules (no outputs needed, just ordering)
dependency "iam" {
  config_path = "../iam"
  
  mock_outputs = {}
  skip_outputs = true
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {}
  skip_outputs = true
}

inputs = {
  environment        = "dev"
  region             = "eu-west-1"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  volume_sizes       = [1, 2, 3, 4]
  
  owner = "Tom"
  email = "tom@ejemplo.com"
}
