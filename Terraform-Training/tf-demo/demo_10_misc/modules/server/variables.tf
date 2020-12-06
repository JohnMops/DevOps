variable "region" {}
variable "instance_type" {}
variable "key_name" {}
variable "az" {}
variable "network_interface" {}
variable "tags" {}
variable "prefix" {}
variable "creator" {
  type = string

  validation {
    condition     = can(regex("[a-zA-Z]", var.creator))
    error_message = "Must contain only letters."
  }
}
variable "create_server" {

}