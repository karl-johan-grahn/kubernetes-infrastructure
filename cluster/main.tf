provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-remote-state-storage-s3-kjg"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "eu-west-1"
    key            = "global/s3/terraform.tfstate"
  }
}

resource "aws_s3_bucket" "kops_state" {
  bucket        = "kops-state-kjg"
  acl           = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
}

output "kops_s3_bucket" {
  value = "${aws_s3_bucket.kops_state.bucket}"
}