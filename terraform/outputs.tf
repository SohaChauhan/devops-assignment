output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.k3s_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.k3s_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.k3s_server.public_dns
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_eip.k3s_server.public_ip}"
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://${aws_eip.k3s_server.public_ip}"
}

output "kubeconfig_command" {
  description = "Command to get kubeconfig"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_eip.k3s_server.public_ip} 'sudo cat /etc/rancher/k3s/k3s.yaml'"
}

