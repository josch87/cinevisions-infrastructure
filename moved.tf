# Resource migrations for renamed resources
# Run: terraform plan to verify, then delete this file after successful apply

# SSH to Bastion rename
moved {
  from = aws_security_group.ssh
  to   = aws_security_group.bastion
}

moved {
  from = aws_vpc_security_group_ingress_rule.ssh_ssh
  to   = aws_vpc_security_group_ingress_rule.bastion_ssh
}

moved {
  from = aws_vpc_security_group_egress_rule.ssh_all
  to   = aws_vpc_security_group_egress_rule.bastion_all
}
