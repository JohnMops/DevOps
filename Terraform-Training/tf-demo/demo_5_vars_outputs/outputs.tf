output "web_server_ip" {
  value = aws_eip.awesome_eip.public_ip
}

output "vpc" {
  value = aws_vpc.prod
}

output "vpc_id" {
  value = aws_vpc.prod.id
}