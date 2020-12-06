locals {
  workspace = terraform.workspace # loads the workspace we are currently in

  env = terraform.workspace # sets the "env" variable as the nae of the workspace

  region = "us-east-1"

  config_map = { # this will determine which locals config we are going to use
    dev = local.dev_config
    prod = local.prod_config
  }

  config = "${lookup(local.config_map, local.workspace)}" # loads the config we are going to use to variable "config"
                                                          # will go into the config_map and loads the appropriate config according to the workspace
}