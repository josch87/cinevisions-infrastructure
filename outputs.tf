output "alb_public_dns" {
  description = "Public DNS of the web servers application load balancer"
  value       = aws_lb.webserver.dns_name
}

output "bastion_host_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion_host.public_ip
}