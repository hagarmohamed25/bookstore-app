/*# terraform/outputs.tf

output "instance_public_ip" {
  description = "The public IP address of the Nexus server."
  value       = aws_instance.nexus_server.public_ip
}

output "nexus_repository_url" {
  description = "The URL of the Docker hosted repository."
  value       = "${aws_instance.nexus_server.public_ip}:8081/repository/docker-hosted/"
}*/

output "nexus_public_ip" {
  description = "The public IP address of the Nexus EC2 instance."
  value       = aws_instance.nexus.public_ip
}