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

variable "key_name" {
}

variable "subnet_block" {
}
variable "instance_type" {}