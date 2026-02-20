provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "CineVisions"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "Aljoscha Zöller"
      Contact     = "dev.aljoschazoeller.com"
    }
  }
}