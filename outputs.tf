output "webserver_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.cinevisions_web_server.public_ip
}

output "webserver_public_dns" {
  description = "Public DNS of the web server"
  value       = aws_instance.cinevisions_web_server.public_dns
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.cinevisions_vpc.id
}