output "backend_private_ip" {
  value = aws_lightsail_instance.backend.private_ip_address
}

output "db_private_ip" {
  value = aws_lightsail_instance.db.private_ip_address
}
