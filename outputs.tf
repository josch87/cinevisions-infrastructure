output "webserver_public_ip" {
  description = "Public IP of the web server"
  value = aws_instance.cinevisions_web_server.public_ip
}

output "webserver_public_dns" {
  value = aws_instance.cinevisions_web_server.public_dns
}