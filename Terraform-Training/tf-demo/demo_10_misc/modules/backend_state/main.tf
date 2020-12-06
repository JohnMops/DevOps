provider "aws" {
  region = var.region
}

# dynamodb table for state lock
resource "aws_dynamodb_table" "terraform_statelock" {
  name           = "${var.env}-terraform-workspace-state-DB-${formatdate("YYYYMMDD", timestamp())}"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

# s3 bucket for terraform state
resource "aws_s3_bucket" "state_bucket" {
  bucket = "${var.env}-terraform-workspace-state-bucket-${formatdate("YYYYMMDD", timestamp())}"
  acl    = "private"

  lifecycle {
    prevent_destroy = false # always change to true to protect this bucket, only put on false while testing
  }

  versioning {
    enabled = true
  }
}