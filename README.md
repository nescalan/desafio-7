# Desafío 7: Implementación de un Sitio Web Estático con AWS y Terraform

## Descripción del Proyecto

Este proyecto tiene como objetivo configurar un sitio web estático utilizando AWS, aplicando infraestructura como código (IaC) con Terraform. Se ha implementado una de las siguientes opciones:

- **Opción 1**: **Amazon S3** como origen para el contenido estático.
- **Opción 2**: **Amazon EC2** con Nginx como servidor de contenido estático.

El sitio es distribuido globalmente utilizando **Amazon CloudFront** para garantizar una entrega rápida y segura.

## Requisitos

1. **AWS Credentials**: Configura tus credenciales de AWS para acceder a la cuenta sandbox de AWS Academy o tu cuenta personal de AWS.
2. **Terraform**: Asegúrate de tener Terraform instalado y configurado en tu entorno.

## Opciones de Implementación

### Opción 1: Bucket de S3

1. **Configura un Bucket de S3** para servir el sitio web estático.
2. **Permisos**: Configura los permisos para que CloudFront pueda acceder al bucket de forma privada.
3. **CloudFront**: Usa una Origin Access Control (OAC) en CloudFront para asegurar que solo CloudFront pueda acceder al contenido del bucket.

### Opción 2: Instancia EC2

1. **Configura una Instancia EC2** con Nginx para servir contenido estático.
2. **Security Groups**: Configura el Security Group para permitir solo tráfico HTTP (puerto 80) desde cualquier lugar y restringir SSH (puerto 22) a tu IP.
3. **CloudFront**: Configura una distribución de CloudFront para servir el contenido desde la instancia EC2.

## Pasos para Implementación

1. **Inicializa Terraform**: Ejecuta `terraform init` para inicializar el proyecto.
2. **Planifica la Infraestructura**: Usa `terraform plan` para ver los cambios que se aplicarán.
3. **Aplica la Infraestructura**: Ejecuta `terraform apply` para provisionar los recursos.
4. **Destruir la Infraestructura**: Al finalizar, usa `terraform destroy` para eliminar los recursos creados y evitar costos adicionales.

## Documentación

### Diagrama de Infraestructura

- **Diagrama 1**: S3 como origen.
- **Diagrama 2**: EC2 como origen.

### Referencias

- [AWS S3 Website Hosting Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Restrict Access to S3 Origin with CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html)

## Entregables

1. Código fuente del proyecto en este repositorio de GitHub.
2. Documentación detallada del proceso de implementación.
3. Evidencia del sitio web funcionando (capturas de pantalla o URL generada por CloudFront).

## Evaluación

- **Entrega Puntual**: El proyecto debe entregarse antes del 18/12/2024.
- **Código Funcional**: Terraform debe desplegar la infraestructura correctamente sin errores.
- **Documentación Clara**: Detalles de cada paso del proceso de implementación.
- **Infraestructura Funcional**: El sitio debe ser accesible a través de CloudFront, ya sea desde S3 o EC2.

## Configuración de Credenciales (si es necesario)

Si estás usando una cuenta personal de AWS, asegúrate de configurar tus credenciales correctamente utilizando el archivo `~/.aws/credentials` o las variables de entorno `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY`.

---

**¡Buena suerte con la implementación!**
