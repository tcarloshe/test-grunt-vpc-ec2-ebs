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
    environment   = "dev"
    region        = "us-east-1"
    instance_type = "t2.micro"
    ebs_sizes     = [8, 8, 5, 5, 8]
    
    tags = {
      environment   = "dev"
      created_by    = "Tom"
      creation_date = "2026-02-24"
      project       = "Terraform WorkShop"
    }
  },
  {
    subnet_ids           = dependency.vpc.outputs.subnet_ids
    iam_instance_profile = dependency.iam.outputs.ec2_instance_profile
  }
)
