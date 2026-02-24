data "aws_default_tags" "default_tags" {}

data "aws_ami" "amazon-linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_iam_instance_profile" "webserver" {
  name = var.iam_instance_profile_webserver
}

data "aws_ssm_parameter" "rds_master_password" {
  name            = "/${var.project_name}/${var.environment}/db/master_password"
  with_decryption = true
}

data "aws_ssm_parameter" "wp_password" {
  name            = "/${var.project_name}/${var.environment}/db/wp_password"
  with_decryption = false # Secret value not needed in decrypted form; Terraform still stores the (encrypted) value in state and this is used only to assert the parameter exists
}