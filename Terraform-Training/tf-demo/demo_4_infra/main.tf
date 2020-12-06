provider "aws" {
  #version = ""
  region = "us-east-1"
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

resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Prod"
  }
}

resource "aws_internet_gateway" "awesome_igw" {
  vpc_id = aws_vpc.prod.id
}

resource "aws_route_table" "awesome_route_table" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.awesome_igw.id
  }

  tags = {
    Name = "Prod"
  }
}

resource "aws_subnet" "awesome_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.prod.id
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table_association" "awesome_rt_accociate" {
  route_table_id = aws_route_table.awesome_route_table.id
  subnet_id = aws_subnet.awesome_subnet.id
}

resource "aws_security_group" "awesome_sg_web_traffic" {
  name = "allow_web_traffic"
  description = "Allow Web traffic on port 80"
  vpc_id = aws_vpc.prod.id

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

resource "aws_network_interface" "awesome_network_interface" {
  subnet_id = aws_subnet.awesome_subnet.id
  private_ips = ["10.0.1.50"]
  security_groups = [aws_security_group.awesome_sg_web_traffic.id]
}

resource "aws_eip" "awesome_eip" {
  depends_on = [aws_internet_gateway.awesome_igw] # Perfect example to the dependency that cannot be resolved by terraform, see documentation
  vpc = true
  network_interface = aws_network_interface.awesome_network_interface.id
  associate_with_private_ip = "10.0.1.50"
}

resource "aws_instance" "awesome_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "mops"

  network_interface {
    device_index = 0 # nic number
    network_interface_id = aws_network_interface.awesome_network_interface.id
  }

  tags = {
    Name = "prod_server"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your first web server > var/www/html/index.html'
              EOF
}

output "web_server_ip" {
  value = aws_eip.awesome_eip.public_ip
}





