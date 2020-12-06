### Locals are considered a part of the tf file family and can be directly referenced from your code without
### going through variables

provider "aws" {
  #version = ""
  region = local.region
  #access_key = ""
  #secret_key = ""
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "pikachu" {
  ami = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
}