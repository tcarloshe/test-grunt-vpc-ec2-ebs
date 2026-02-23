terraform {
  backend "s3" {
    bucket         = "tom-my-tf-state"
    key            = "root/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}
