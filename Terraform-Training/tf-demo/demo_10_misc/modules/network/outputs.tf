output "vpc" {
  value = aws_vpc.prod
}
output "network_interface" {
  value = aws_network_interface.awesome_network_interface.*.id
}