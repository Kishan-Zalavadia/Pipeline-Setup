output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.backend.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_eip.backend.public_ip
}

output "public_dns" {
  description = "EC2 public DNS"
  value       = aws_eip.backend.public_dns
}

output "backend_url" {
  description = "Backend API URL"
  value       = "http://${aws_eip.backend.public_ip}:5050"
}

output "private_key" {
  description = "The generated private key in PEM format"
  value       = tls_private_key.main.private_key_pem
  sensitive   = true
}
