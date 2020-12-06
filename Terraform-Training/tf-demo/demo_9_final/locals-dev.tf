locals {

  dev_config = {
    network= {

      az = "us-east-1a"
      cidr_block = "10.0.0.0/16"
      prefix = local.env
      private_ips = ["10.0.1.50"]
      subnet_block = "10.0.1.0/24"

    }
    server = {

      az = "us-east-1a"
      instance_type = "t3.micro"
      key_name = "mops"
      prefix = local.env

    }

    tags = { # a way to control the tags consistency across all resources

      environment   = local.env # general locals.tf
      created_by    = "John"

    }



  }
}