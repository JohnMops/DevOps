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

resource "aws_instance" "awesome_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  availability_zone = var.az
  key_name = var.key_name

  network_interface {
    device_index = 0 # nic number
    network_interface_id = var.network_interface
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