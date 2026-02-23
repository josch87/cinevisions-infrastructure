variable "aws_profile" {
  description = "(Optional) AWS profile to use for deployment"
  type        = string
  default     = null
}

variable "project_name" {
  description = "(Required) Project name for resource naming and isolation"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*$", var.project_name))
    error_message = "project_name must start with a letter and contain only lowercase letters, numbers, and hyphens"
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9]*$", replace(var.project_name, "-", "")))
    error_message = "project_name must remain valid for RDS database naming when hyphens are removed (must start with a letter)"
  }
}

variable "owner" {
  description = "(Required) Owner for resource tagging and isolation"
  type        = string
  default     = "Aljoscha Zöller - dev.aljoschazoeller.com"

  validation {
    condition     = can(regex("^[\\p{L}0-9 _.:/=+\\-@]*$", var.owner))
    error_message = "owner may only contain unicode letters, digits, whitespace, or these symbols: _ . : / = + - @"
  }
}

variable "environment" {
  description = "(Required) Environment to deploy into"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment needs to be one of 'dev', 'staging', or 'prod'"
  }
}

variable "aws_region" {
  description = "(Optional) AWS region to deploy into"
  type        = string
  default     = "us-west-2"
}

variable "aws_availability_zones" {
  description = "(Optional) Availability zones by key"
  type        = map(string)
  default = {
    az1 = "us-west-2a",
    az2 = "us-west-2b",
  }

  validation {
    condition = (
      length(var.aws_availability_zones) == 2 &&
      alltrue([for k in ["az1", "az2"] : contains(keys(var.aws_availability_zones), k)]) &&
      length(distinct(values(var.aws_availability_zones))) == 2
    )
    error_message = "aws_availability_zones must contain exactly two unique availability zones with keys 'az1' and 'az2'."
  }
}

variable "vpc_cidr" {
  description = "(Optional) CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_1_cidr" {
  description = "(Optional) CIDR block for the public subnet 1"
  type        = string
  default     = "10.0.0.0/28"
}

variable "private_subnet_1_cidr" {
  description = "(Optional) CIDR block for the private subnet 1"
  type        = string
  default     = "10.0.0.16/28"
}

variable "public_subnet_2_cidr" {
  description = "(Optional) CIDR block for the public subnet 2"
  type        = string
  default     = "10.0.0.32/28"
}

variable "private_subnet_2_cidr" {
  description = "(Optional) CIDR block for the private subnet 2"
  type        = string
  default     = "10.0.0.48/28"
}

variable "webserver_instance_type" {
  description = "(Optional) Instance type for the web server"
  type        = string
  default     = "t3.micro"
}

variable "my_local_public_ip" {
  description = "(Required) My public IP address in CIDR notation (must be /32), e.g. 92.211.3.2/32 for SSH access to webserver"
  type        = string
}

variable "key_name" {
  description = "(Required) Name of the SSH key pair to use for the web server"
  type        = string
}

variable "iam_instance_profile_webserver" {
  description = "Name of an existing IAM instance profile to attach to the web server EC2 instance (expects the instance profile name, e.g. \"LabInstanceProfile\", not a role name or ARN). In the sandbox this must be provided because Terraform cannot create IAM roles/profiles."
  type        = string
}