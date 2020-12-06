variable "region" {
  default = "us-east-1"
}


variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "az" {
  default = "us-east-1a"
}

variable "prefix" {
  default = "mops"
}

variable "private_ips" {
  type = list(string)
  default = ["10.0.1.50"]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "mops"
}

variable "subnet_block" {
  default = "10.0.1.0/24"
}