resource "aws_instance" "segunda_prueba" {
    ami           = "ami-0885b1f6bd170450c"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["sg-02fb97a21ba2fafa6"]
    key_name = "llaves-nel"

    # Script de inicialización para instalar Apache
    user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get install apache2 -y
                systemctl start apache2
                systemctl enable apache2
                echo "<h1>¡Hola desde Apache en Ubuntu Server!</h1>" > /var/www/html/index.html
                EOF


    tags = {
        Name = "Prueba con variables y apache2"
    }
}

