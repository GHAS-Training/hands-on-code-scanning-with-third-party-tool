output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.insecure_instance.public_ip # **Vulnerability: Exposing Public IP in Output**
}