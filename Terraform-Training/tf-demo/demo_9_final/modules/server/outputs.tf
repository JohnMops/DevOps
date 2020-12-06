output "server_ip" {
  value = aws_instance.awesome_instance.public_ip
}
