output "instance_id" {
  value       = "aws_instance.blockstellart.id"
  description = "ID de la instancia EC2"
}
output "instance_public_ip" {
  value       = "aws_instance.blockstellart.public_ip"
  description = "IP publica de la instancia EC2"
}

