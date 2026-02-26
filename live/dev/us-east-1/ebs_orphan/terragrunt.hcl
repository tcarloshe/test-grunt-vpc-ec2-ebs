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
  region             = "us-east-1"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  volume_sizes       = [1, 2, 3, 4]
  
  owner = "Tom"
  email = "tom@ejemplo.com"
}
