resource "aws_efs_file_system" "wordpress_content" {
  creation_token = "wordpress-content"

  tags = {
    Name = "${local.name_prefix}-wordpress-content-efs"
  }
}