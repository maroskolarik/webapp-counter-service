output "wcs-server-public-ip" {
  description = "public IP of the WCS server instance"
  value       = aws_instance.wcs-server.public_ip
}

output "wcs-monitoring-public-ip" {
  description = "public IP of the WCS monitoring server instance"
  value       = aws_instance.wcs-monitoring.public_ip
}