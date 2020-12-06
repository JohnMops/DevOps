provider "aws" {
  #version = ""
  region = "us-east-1"
  #access_key = ""
  #secret_key = ""
}

### https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

resource "aws_instance" "pikachu" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = "t3.micro"
/*
  tags = {
    Name = "Pika-Pika"
  }
*/
}