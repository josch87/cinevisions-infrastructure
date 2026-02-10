variable "aws_profile" {
  type = string
  default = null
}

variable "environment" {
  description = "Environment to deploy into"
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment needs to be 'dev' or 'prod'"
  }

}

variable "aws_region" {
  description = "AWS region to deploy into"
  type = string
  default = "us-west-2"
}

variable "cinevisions_vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/24"
}