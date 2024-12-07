provider "aws" {
  region = "us-east-1" # Cambia según tu región
}

# Recurso para crear una instancia de EC2
resource "aws_instance" "ubuntu_server" {
  ami           = "ami-0885b1f6bd170450c" # AMI pública de Ubuntu 20.04 LTS en us-east-1
  instance_type = "t2.micro"

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
    Name = "Ubuntu-Server for desafio-7"
  }
}
