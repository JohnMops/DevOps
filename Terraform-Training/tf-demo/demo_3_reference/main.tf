provider "aws" {
  #version = ""
  region = "us-east-1"
  #access_key = ""
  #secret_key = ""
}

resource "aws_vpc" "narnia" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Worst Movie Ever"
  }
}

resource "aws_subnet" "lord_of_the_rings" {
  cidr_block = "10.0.1.0/24"
  vpc_id =  aws_vpc.narnia.id# Reference to our narnia vpc

  tags = {
    Name = "Legendary Movie"
  }
}

### The order of the resources does not matter, you can put the subnets before the vpc
### Terraform knows what needs to get created first and chain all the resources together (not always the case)



