provider "aws" {
  #version = ""
  region = "us-east-1"
  #access_key = ""
  #secret_key = ""
}


module "network" {
  source = "./modules/network"

  az            = local.config.network.az #remember locals.tf flow: local > config from config_map > name of the local config
  cidr_block    = local.config.network.cidr_block
  prefix        = local.config.network.prefix
  private_ips   = local.config.network.private_ips
  region        = local.region # taken directly from the general locals
  subnet_block  = local.config.network.subnet_block
  tags          = local.config.tags
  create_server = local.config.server.create_server
}

module "server" {
  depends_on = [module.network]
  source     = "./modules/server"

  az                = local.config.server.az
  instance_type     = local.config.server.instance_type
  key_name          = local.config.server.key_name
  network_interface = module.network.network_interface # still taking from module/network/outputs
  region            = local.region                     # again from the general locals.tf
  tags              = local.config.tags
  prefix            = local.config.server.prefix
  creator           = local.config.tags.created_by
  create_server     = local.config.server.create_server
}