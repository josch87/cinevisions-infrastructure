#!/bin/bash

# Set profile
if [ -f ~/.aws/config ] || [ -f ~/.aws/credentials ]; then
	echo "Available AWS profiles:"
	{
		[ -f ~/.aws/config ] && grep -E '^\[profile ' ~/.aws/config | sed 's/\[profile \(.*\)\]/\1/'
		[ -f ~/.aws/credentials ] && grep -E '^\[' ~/.aws/credentials | sed 's/\[\(.*\)\]/\1/'
	} | sort -u | sed 's/^/  - /'
	echo
fi
echo "Which AWS CLI profile do you want to use?"
read -rp "Profile [default]: " PROFILE
PROFILE=${PROFILE:-default}
echo "Using the '${PROFILE}'-Profile for all connections to the AWS CLI."
echo

# Set project name
while true; do
	echo "For which project do you want to set the password?"
	read -rp "Project name: " PROJECT_NAME
	
	if [[ "$PROJECT_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
		break
	else
		echo "Error: Project name must start with a letter and contain only lowercase letters, numbers, and hyphens."
		echo
	fi
done
echo

# Set environment
echo "For which environment do you want to set the passwords?"
read -rp "[dev|staging|prod]: " ENVIRONMENT

case "$ENVIRONMENT" in
	dev|staging|prod)
		echo "Valid Value"
		;;
	*)
		echo "Invalid Value"
		exit 1
		;;
esac
echo

# Ask for passwords
read -rsp "DB Master Password: " DB_MASTER_PASSWORD
echo
read -rsp "DB Password: " DB_PASSWORD
echo


# Save passwords
aws ssm put-parameter \
	--name "/${PROJECT_NAME}/${ENVIRONMENT}/db/master_password" \
	--type "SecureString" \
	--value $DB_MASTER_PASSWORD \
	--overwrite \
	--profile $PROFILE

aws ssm put-parameter \
	--name "/${PROJECT_NAME}/${ENVIRONMENT}/db/wp_password" \
	--type "SecureString" \
	--value $DB_PASSWORD \
	--overwrite \
	--profile $PROFILE

