# Proveedor de AWS: Especifica la región donde se crearán los recursos
provider "aws" {
  region = "us-east-1"  # Cambia según tu región preferida
}

# Recurso S3 Bucket: Define un bucket para alojar el sitio web estático
resource "aws_s3_bucket" "static_site" {
  bucket = "desafio-siete-aws" # Nombre único del bucket

  tags = {
    Name = "StaticWebsiteBucket" # Etiqueta para identificar el propósito del bucket
  }
}

# Política del Bucket S3: Configura permisos para que CloudFront acceda al bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_site.id  # Aplica esta política al bucket definido anteriormente

  policy = jsonencode({
    Version = "2012-10-17"  # Versión de la política
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess"  # Identificador único de la política
        Effect    = "Allow"                 # Permite acceso
        Principal = {
          Service = "cloudfront.amazonaws.com"  # Específica que CloudFront tendrá acceso
        }
        Action    = "s3:GetObject"  # Permite leer objetos del bucket
        Resource  = "${aws_s3_bucket.static_site.arn}/*"  # Aplica a todos los objetos del bucket
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.site_distribution.arn
            # Restringe el acceso para que solo esta distribución de CloudFront pueda acceder
          }
        }
      }
    ]
  })
}

# Configuración de Sitio Web en S3: Habilita el bucket para servir como un sitio web estático
resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.static_site.id  # Bucket al que se aplica esta configuración

  index_document {
    suffix = "index.html"  # Archivo que se cargará como página principal
  }

  error_document {
    key = "error.html"  # Archivo que se mostrará en caso de error
  }
}

# Control de Acceso de Origen para CloudFront: Configura acceso de CloudFront al bucket S3
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "S3OAC"  # Nombre del control de acceso
  origin_access_control_origin_type = "s3"     # Específico para S3
  signing_behavior                  = "always" # Siempre firmará las solicitudes a S3
  signing_protocol                  = "sigv4"  # Protocolo de firma para seguridad
}

# Distribución de CloudFront: Configura la entrega de contenido desde S3
resource "aws_cloudfront_distribution" "site_distribution" {
  enabled             = true  # Activa la distribución
  default_root_object = "index.html"  # Página principal predeterminada

  # Configuración de origen: Conecta CloudFront con el bucket S3
  origin {
    domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name  # Dominio del bucket S3
    origin_id   = "S3Origin"  # Identificador del origen
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    # Asocia el control de acceso con este origen
  }

  # Configuración del comportamiento de caché predeterminado
  default_cache_behavior {
    target_origin_id       = "S3Origin"           # Origen asociado
    viewer_protocol_policy = "redirect-to-https" # Redirige todo el tráfico a HTTPS

    allowed_methods = ["GET", "HEAD"]  # Métodos permitidos para los usuarios
    cached_methods  = ["GET", "HEAD"]  # Métodos que se almacenarán en caché

    # Configuración de valores reenviados
    forwarded_values {
      query_string = false  # No reenvía cadenas de consulta al origen
      cookies {
        forward = "none"    # No reenvía cookies al origen
      }
    }

    # Configuración de tiempos de vida de los objetos en caché
    min_ttl     = 0      # Tiempo mínimo en caché (0 segundos)
    default_ttl = 3600   # Tiempo por defecto en caché (1 hora)
    max_ttl     = 86400  # Tiempo máximo en caché (1 día)
  }

  # Configuración del certificado SSL
  viewer_certificate {
    cloudfront_default_certificate = true  # Usa el certificado predeterminado de CloudFront
  }

  # Restricciones geográficas
  restrictions {
    geo_restriction {
      restriction_type = "none"  # No hay restricciones geográficas
    }
  }

  tags = {
    Name = "StaticSiteCloudFrontDistribution"  # Etiqueta para identificar la distribución
  }
}

# Salida: Muestra la URL de la distribución de CloudFront
output "cloudfront_url" {
  value       = aws_cloudfront_distribution.site_distribution.domain_name  # Dominio de CloudFront
  description = "URL del sitio web servida por CloudFront"  # Descripción del propósito del output
}
