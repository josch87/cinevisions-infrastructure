locals {
  name_prefix = "${var.project_name}-${var.environment}"
  db_name     = replace(var.project_name, "-", "")
}