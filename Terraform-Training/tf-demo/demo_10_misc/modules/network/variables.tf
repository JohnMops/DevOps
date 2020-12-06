variable "region" {
}


variable "cidr_block" {
}

variable "az" {
}

variable "prefix" {
}

variable "private_ips" {
  type = list(string)
}

variable "subnet_block" {
}

variable "tags" {}

variable "subnet_numbers" {
  description = "List of 8-bit numbers of subnets of base_cidr_block that should be granted access."
  default = [1, 2, 3]
}

variable "create_server" {

}