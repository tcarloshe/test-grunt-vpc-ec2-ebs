include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/ec2"
}

# Dependencies on other modules
dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    subnet_ids = ["subnet-mock-1", "subnet-mock-2"]
  }
  skip_outputs = false
}

dependency "iam" {
  config_path = "../iam"
  
  mock_outputs = {
    ec2_instance_profile = "mock-profile"
  }
  skip_outputs = false
}

inputs = merge(
  {
    environment   = "prod"
    region        = "us-east-1"
    instance_type = "t3.small"
    ebs_sizes     = [20, 20, 10, 10, 15]
    
    tags = {
      environment   = "prod"
      created_by    = "Tom"
      creation_date = "2026-02-25"
      project       = "Terraform WorkShop"
    }
  },
  {
    subnet_ids           = dependency.vpc.outputs.subnet_ids
    iam_instance_profile = dependency.iam.outputs.ec2_instance_profile
  }
)
