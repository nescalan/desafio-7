terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "4.31.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

# Crea un grupo de seguridad para 
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crea una instancia EC2 
resource "aws_instance" "ubuntu_server" {
  ami           = "ami-0885b1f6bd170450c" # AMI pública de Ubuntu 20.04 LTS en us-east-1
  instance_type = "t2.micro"
  key_name      = "llaves-nel"

  # Script de inicialización para instalar Apache
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install apache2 -y
              systemctl start apache2
              systemctl enable apache2
              echo "¡Hola desde Apache en Ubuntu Server!" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Ubuntu-Server"
  }

  # Asocia el grupo de seguridad
  vpc_security_group_ids = [aws_security_group.allow_http.id]
}

