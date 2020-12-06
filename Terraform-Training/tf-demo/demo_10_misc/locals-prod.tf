locals {

  prod_config = {
    network= {

      az = "us-east-1b"
      cidr_block = "10.1.0.0/16"
      prefix = local.env
      private_ips = ["10.1.4.55","10.1.4.50"]
      subnet_block = "10.1.0.0/24"

    }
    server = {

      create_server = false
      az = "us-east-1b"
      instance_type = "t3.large"
      key_name = "mops"
      prefix = local.env

    }
    tags = { # a way to control the tags consistency across all resources

      environment   = local.env # general locals.tf
      created_by    = "John"

    }


  }
}