#!/bin/bash -e

# Set Variables
DBName="cinevisions"
DBUser="wordpress"
DBPassword=$(aws ssm get-parameters --names "/cinevisions/${environment}/db/wp_password" --query="Parameters[0].Value" --with-decryption --output text)
DBRootPassword=$(aws ssm get-parameters --names "/cinevisions/${environment}/db/master_password" --query="Parameters[0].Value" --with-decryption --output text)
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
echo "CREATE DATABASE IF NOT EXISTS $DBName;" | mysql -u root --password="$DBRootPassword"
echo "CREATE USER IF NOT EXISTS '$DBUser'@'localhost' IDENTIFIED BY '$DBPassword';" | mysql -u root --password="$DBRootPassword"
echo "GRANT ALL ON $DBName.* TO '$DBUser'@'localhost';" | mysql -u root --password="$DBRootPassword"
echo "FLUSH PRIVILEGES;" | mysql -u root --password="$DBRootPassword"

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

# Fetch and inject WordPress secret keys/salts into wp-config.php
SALTS_FILE="$(mktemp)"
curl -fsSL "https://api.wordpress.org/secret-key/1.1/salt/" > "$SALTS_FILE"
test -s "$SALTS_FILE"

awk -v salts="$SALTS_FILE" '
  BEGIN { inserted=0; skipping=0 }

  # Start: when AUTH_KEY is found, output the new salts and start skipping the old block
  $0 ~ /define\(\s*\x27AUTH_KEY\x27/ {
    if (!inserted) { system("cat " salts); inserted=1 }
    skipping=1
    next
  }

  # Skip everything until (and including) NONCE_SALT, so comments/blank lines inside the block do not matter
  skipping == 1 {
    if ($0 ~ /define\(\s*\x27NONCE_SALT\x27/) { skipping=0 }
    next
  }

  { print }
' wp-config.php > wp-config.php.new

mv wp-config.php.new wp-config.php
rm -f "$SALTS_FILE"

# Grant permissions
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www/
chmod 2755 /var/www/
find /var/www/ -type d -exec chmod 2775 {} \;
find /var/www/ -type f -exec chmod 0664 {} \;
chmod 440 /var/www/wp-config.php
