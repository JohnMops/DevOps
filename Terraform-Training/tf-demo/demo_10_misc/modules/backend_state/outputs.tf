output "dynamo_db" {
  value = aws_dynamodb_table.terraform_statelock.name
}
output "bucket_name" {
  value = aws_s3_bucket.state_bucket.id
}