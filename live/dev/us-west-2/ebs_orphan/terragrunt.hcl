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
  region             = "us-west-2"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  volume_sizes       = [1, 2, 3, 4]
  
  owner = "Tom"
  email = "tom@ejemplo.com"
}
