terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "access_key"
  secret_key = "secret_key"
}

resource "aws_instance" "my-first-server" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  key_name   = "id_rsa"
  availability_zone = "us-east-1a"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo ufw allow 'Nginx HTTP'
              sudo rm /etc/nginx/sites-enabled/default
              sudo mkdir Downloads
              cd Downloads
              sudo wget https://raw.githubusercontent.com/skiesluv/terraform_nginx_confin/main/terra.conf
              sudo cp terra.conf /etc/nginx/conf.d/
              sudo nginx -t
              sudo systemctl restart nginx
              cd
              EOF

  provisioner "local-exec" {
    command = "echo ${aws_instance.my-first-server.public_ip} >> IP_address.txt"
  }
}

resource "aws_instance" "my-2-server" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  key_name   = "id_rsa"
  availability_zone = "us-east-1a"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo ufw allow 'Nginx HTTP'
              sudo bash -c 'echo Server 1 > /var/www/html/index.html'
              EOF

  provisioner "local-exec" {
    command = "echo ${aws_instance.my-2-server.public_ip} >> IP_address.txt"
  }
}

resource "aws_instance" "my-3-server" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  key_name   = "id_rsa"
  availability_zone = "us-east-1a"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo ufw allow 'Nginx HTTP'
              sudo bash -c 'echo Server 2 > /var/www/html/index.html'
              EOF

  provisioner "local-exec" {
    command = "echo ${aws_instance.my-3-server.public_ip} >> IP_address.txt"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "id_rsa"
  public_key = "ssh key"
}