#!/bin/bash

# Set profile
echo "Which AWS CLI profile do you want to use?"
read -p "Profile: " PROFILE
PROFILE=${PROFILE:-default}
echo "Using the '${PROFILE}'-Profile for all connections to the AWS CLI."


# Set project name
echo "For which project do you want to set the password?"
read -p "Project name: " PROJECT_NAME


# Set environment
echo "For which environment do you want to set the passwords?"
read -p "[dev|staging|prod]: " ENVIRONMENT

case "$ENVIRONMENT" in
	dev|staging|prod)
		echo "Valid Value"
		;;
	*)
		echo "Invalid Value"
		exit 1
		;;
esac


# Ask for passwords
read -sp "DB Master Password: " DBMasterPassword
echo
read -sp "DB Password: " DBPassword
echo


# Save passwords
aws ssm put-parameter \
	--name "/${PROJECT_NAME}/${ENVIRONMENT}/db/master_password" \
	--type "SecureString" \
	--value $DBMasterPassword \
	--overwrite \
	--profile $PROFILE

aws ssm put-parameter \
	--name "/${PROJECT_NAME}/${ENVIRONMENT}/db/wp_password" \
	--type "SecureString" \
	--value $DBPassword \
	--overwrite \
	--profile $PROFILE

