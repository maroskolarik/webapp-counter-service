output "wcs-server-private-ip" {
  description = "private IP of the WCS server instance"
  value       = aws_instance.wcs-server.private_ip
}

output "wcs-server-public-ip" {
  description = "public IP of the WCS server instance"
  value       = aws_instance.wcs-server.public_ip
}