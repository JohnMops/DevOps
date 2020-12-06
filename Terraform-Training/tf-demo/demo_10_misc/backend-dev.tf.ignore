terraform {
  backend "s3" {
    bucket         = "dev-terraform-workspace-state-bucket-20200815"
    dynamodb_table = "dev-terraform-workspace-state-DB-20200815"
    key            = "dev.state"
    encrypt        = true
    region = "us-east-1"
  }
}
