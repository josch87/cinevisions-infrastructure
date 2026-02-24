resource "aws_efs_file_system" "wordpress_content" {
  creation_token = "wordpress-content"

  tags = {
    Name = "${local.name_prefix}-wordpress-content-efs"
  }
}

resource "aws_efs_mount_target" "private_1" {
  file_system_id = aws_efs_file_system.wordpress_content.id
  subnet_id      = aws_subnet.private_1.id
}

resource "aws_efs_mount_target" "private_2" {
  file_system_id = aws_efs_file_system.wordpress_content.id
  subnet_id      = aws_subnet.private_2.id
}