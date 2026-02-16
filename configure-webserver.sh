#!/bin/bash -e

# Set Variables
DBName="cinevisions"
DBUser="wordpress"
DBPassword=$(aws ssm get-parameters --names "/cinevisions/wordpress/db_password" --query="Parameters[0].Value" --with-decryption)
DBRootPassword=$(aws ssm get-parameters --names "/cinevisions/wordpress/db_root_password" --query="Parameters[0].Value" --with-decryption)
DBHost="localhost"
WebRoot="/var/www/html"

# Install PHP and other tools
dnf install -y php8.5
systemctl enable php-fpm
systemctl start php-fpm
dnf install -y php8.5-mysqlnd.x86_64

# Install Apache2
dnf install -y httpd
systemctl enable httpd
systemctl start httpd

# Install MariaDB 10.11
dnf install -y mariadb1011-server.x86_64
systemctl enable mariadb
systemctl start mariadb
sleep 10

# Set MariaDB root password
mysqladmin -u root password "$DBRootPassword"

# Create WordPress database
echo "CREATE DATABASE IF NOT EXISTS $DBName;" | mysql -u root --password=$DBRootPassword
echo "CREATE USER IF NOT EXISTS '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" | mysql -u root --password=$DBRootPassword
echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" | mysql -u root --password=$DBRootPassword
echo "FLUSH PRIVILEGES;" | mysql -u root --password=$DBRootPassword

# Download and install WordPress
wget https://wordpress.org/latest.tar.gz -P $WebRoot
cd $WebRoot
tar -zxvf latest.tar.gz
cp -rvf wordpress/* .
rm -R wordpress/ latest.tar.gz

# Create wp-config.php (one folder above WebRoot)
cp ./wp-config-sample.php ../wp-config.php
cd ../
sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
sed -i "s/'localhost'/'$DBHost'/g" wp-config.php

# Grant permissions
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www/
chmod 2755 /var/www/
find /var/www/ -type d -exec chmod 2775 {} \;
find /var/www/ -type f -exec chmod 0664 {} \;
chmod 440 /var/www/wp-config.php
