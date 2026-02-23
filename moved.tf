# Resource migrations for renamed resources
# Run: terraform plan to verify, then delete this file after successful apply

# Network resources
moved {
  from = aws_vpc.cinevisions_vpc
  to   = aws_vpc.main
}

moved {
  from = aws_subnet.cinevisions_public_subnet_1
  to   = aws_subnet.public_1
}

moved {
  from = aws_subnet.cinevisions_public_subnet_2
  to   = aws_subnet.public_2
}

moved {
  from = aws_subnet.cinevisions_private_subnet_1
  to   = aws_subnet.private_1
}

moved {
  from = aws_subnet.cinevisions_private_subnet_2
  to   = aws_subnet.private_2
}

moved {
  from = aws_internet_gateway.cinevisions_igw
  to   = aws_internet_gateway.main
}

moved {
  from = aws_default_route_table.cinevisions_default_rt
  to   = aws_default_route_table.main
}

moved {
  from = aws_route_table.cinevisions_public_rt
  to   = aws_route_table.public
}

moved {
  from = aws_route_table_association.cinevisions_public_subnet_1_assoc_public_rt
  to   = aws_route_table_association.public_1
}

moved {
  from = aws_route_table_association.cinevisions_public_subnet_2_assoc_public_rt
  to   = aws_route_table_association.public_2
}

# Security resources
moved {
  from = aws_security_group.webserver_sg
  to   = aws_security_group.webserver
}

moved {
  from = aws_vpc_security_group_ingress_rule.webserver_sg_ingress_http
  to   = aws_vpc_security_group_ingress_rule.webserver_http
}

moved {
  from = aws_vpc_security_group_egress_rule.webserver_sg_egress_all
  to   = aws_vpc_security_group_egress_rule.webserver_all
}

moved {
  from = aws_security_group.ssh_sg
  to   = aws_security_group.ssh
}

moved {
  from = aws_vpc_security_group_ingress_rule.ssh_sg_ingress_ssh
  to   = aws_vpc_security_group_ingress_rule.ssh_ssh
}

moved {
  from = aws_vpc_security_group_egress_rule.ssh_sg_egress_all
  to   = aws_vpc_security_group_egress_rule.ssh_all
}

moved {
  from = aws_security_group.rds_sg
  to   = aws_security_group.rds
}

moved {
  from = aws_vpc_security_group_ingress_rule.rds_sg_ingress_mariadb
  to   = aws_vpc_security_group_ingress_rule.rds_mariadb
}

moved {
  from = aws_vpc_security_group_egress_rule.rds_sg_egress_all
  to   = aws_vpc_security_group_egress_rule.rds_all
}

# Compute resources
moved {
  from = aws_instance.cinevisions_web_server
  to   = aws_instance.webserver
}

# Database resources
moved {
  from = aws_db_subnet_group.rds_subnet_group
  to   = aws_db_subnet_group.database
}

moved {
  from = aws_db_instance.mariadb_rds
  to   = aws_db_instance.mariadb
}
