
resource "aws_instance" "awesome_instance" {
  count             = var.create_server ? 2 : 1
  ami               = data.aws_ami.ubuntu.id # even though it is in a different file, terraform does not care
  instance_type     = var.instance_type
  availability_zone = var.az
  key_name          = var.key_name

  network_interface {
    device_index         = 0 # nic number
    network_interface_id = var.network_interface[count.index]
  }

  tags = {
    Name        = "${var.prefix}_web_server_${count.index}",
    environment = var.prefix,
    created_by  = var.creator
  }


  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo your first web server > var/www/html/index.html'
              EOF
}


