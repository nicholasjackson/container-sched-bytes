terraform {
  backend "s3" {
    bucket  = "nic-terraform-state"
    key     = "examples/container-sched-bytes/terraform.state"
    region  = "eu-west-1"
    profile = "hashicorp"
  }
}
