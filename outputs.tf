output "webserver_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.webserver.public_ip
}

output "webserver_public_dns" {
  description = "Public DNS of the web server"
  value       = aws_instance.webserver.public_dns
}

output "bastion_host_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.bastion_host.public_ip
}