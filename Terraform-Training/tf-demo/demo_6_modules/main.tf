provider "aws" {
  #version = ""
  region = var.region
  #access_key = ""
  #secret_key = ""
}

module "network" {
  source = "./modules/network"
  az = var.az
  cidr_block = var.cidr_block
  instance_type = var.instance_type
  key_name = var.key_name
  prefix = var.prefix
  private_ips = var.private_ips # list
  region = var.region
  subnet_block = var.subnet_block
}

module "server" {
  depends_on = [module.network]
  source = "./modules/server"
  az = var.az
  instance_type = var.instance_type
  key_name = var.key_name
  region = var.region
  network_interface = module.network.network_interface # network has this object as an output
}