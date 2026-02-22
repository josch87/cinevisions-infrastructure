# CineVisions Infrastructure

This Terraform project provisions AWS infrastructure for a WordPress-based web application with automated server configuration.

## Overview

The infrastructure includes:
- VPC with public and private subnets across two availability zones
- EC2 instance running WordPress on Apache
- RDS MariaDB 11.8 instance in private subnets (Multi-AZ)
- Security groups for HTTP, SSH, and Database access
- Automated WordPress installation and configuration via user data script

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.2 installed
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions
- Your public IP address for SSH access

## Setup

1. **Configure AWS Credentials**

   Configure your AWS credentials via AWS CLI:
   ```bash
   aws configure [--profile sandbox]
   ```

2. **Create Required SSM Parameters**

   Use the provided script to set database credentials:
   ```bash
   bash scripts/set-db-credentials.sh
   ```

   Or manually create these AWS Systems Manager Parameter Store values:
   ```bash
   aws ssm put-parameter --name "/<project_name>/<environment>/db/master_password" --value "your-db-root-password" --type "SecureString"
   aws ssm put-parameter --name "/<project_name>/<environment>/db/wp_password" --value "your-wordpress-db-password" --type "SecureString"
   ```

3. **Configure Variables**

   Create a `terraform.tfvars` file with required variables:
   ```hcl
   project_name                   = "cinevisions"
   environment                    = "dev"      # or "staging", "prod"
   aws_profile                    = "sandbox"  # optional, only if using a non-default AWS profile
   my_local_public_ip             = "YOUR.IP.ADDRESS/32"
   iam_instance_profile_webserver = "LabInstanceProfile"
   key_name                       = "vockey"
   ```

   Optional variables (with defaults):
   - `aws_region`: AWS region (default: us-west-2)
   - `aws_availability_zones`: Map of availability zones (defaults to us-west-2a and us-west-2b)
   - `vpc_cidr`: VPC CIDR block (default: 10.0.0.0/24)
   - `webserver_instance_type`: EC2 instance type (default: t3.micro)
   - Subnet CIDR blocks (see `variables.tf` for defaults)

## Deployment

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Review the Plan**
   ```bash
   terraform plan
   ```

3. **Apply the Configuration**
   ```bash
   terraform apply
   ```

4. **Access WordPress**

   After deployment completes, Terraform will output:
   - `webserver_public_ip`: Public IP address of the web server
   - `webserver_public_dns`: Public DNS name of the web server

   Navigate to `http://<webserver_public_ip>` to complete WordPress setup.

## Architecture

![Architecture Diagram](diagram/architecture-diagram_level2.png)

- **Network**: Multi-AZ VPC with public and private subnets across two availability zones
- **Compute**: Single EC2 instance (Amazon Linux 2023) in public subnet with automated configuration
- **Database**: Managed MariaDB 11.8 RDS instance in private subnets (Multi-AZ, encrypted storage)
- **Web Server**: Apache HTTP Server with PHP 8.5
- **CMS**: WordPress (latest version)
- **Monitoring**: CloudWatch logs enabled for RDS (error, general, slowquery)

## Security

- SSH access restricted to `my_local_public_ip`
- HTTP (port 80) open to the internet
- RDS database access restricted to the web server security group
- Database credentials stored in AWS Systems Manager Parameter Store (SecureString)
- WordPress config file permissions set to 440
- RDS storage encryption enabled
- SSL/TLS connection to RDS enforced (MYSQLI_CLIENT_SSL)
- Deletion protection enabled for production environment
- Automated backups (10 days retention for prod, 1 day for dev/staging)

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## File Structure

- `terraform.tf`: Terraform and provider version requirements
- `providers.tf`: AWS provider configuration with default tags
- `variables.tf`: Input variable definitions with validation
- `locals.tf`: Local values for resource naming
- `network.tf`: VPC, subnets, internet gateway, and route tables
- `security.tf`: Security groups (Webserver, SSH, RDS)
- `compute.tf`: EC2 instance with Amazon Linux 2023 AMI
- `database.tf`: RDS MariaDB instance, subnet group, and SSM parameter data sources
- `random.tf`: Random ID generation for RDS final snapshot
- `outputs.tf`: Output definitions
- `configure-webserver.sh.tftpl`: User data script template for WordPress installation
- `scripts/set-db-credentials.sh`: Helper script to set SSM parameters
- `moved.tf`: Resource move operations (if applicable)
