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

variable "aws_availability_zones" {
  description = "Availability zones by key"
  type = map(string)
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

variable "cinevisions_vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/24"
}

variable "cinevisions_public_subnet_1_cidr" {
  description = "CIDR block for the public subnet 1"
  type = string
  default = "10.0.0.0/28"
}