#!/bin/bash -x
exec > >(tee /var/log/userdata.log) 2>&1
sudo yum update -y
sudo yum install -y nfs-utils
#EFS CREATION AND MOUNTING
TOKEN=$(curl --request PUT "http://169.254.169.254/latest/api/token" --header "X-aws-ec2-metadata-token-ttl-seconds: 3600")
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region --header "X-aws-ec2-metadata-token: $TOKEN")

MOUNT_POINT="${MOUNT_POINT}"
sudo mkdir -p ${MOUNT_POINT}
sudo chown ec2-user:ec2-user ${MOUNT_POINT}
#echo aws_efs_file_system.web-app-efs.id.efs.var.region.amazonaws.com:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab
echo ${file_system_id}.efs.${region}.amazonaws.com:/ ${MOUNT_POINT} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0 >> /etc/fstab

#Mount the EFS file system
sudo mount -a -t nfs4

#Install the needed packages and enable the services(MariaDb, Apache)
sudo chmod -R 755 /var/www/html

#Update the system packages
sudo yum update -y
# install LAMP stack using Amazon Linux extras
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
# Start and enable Apache HTTP Server
sudo systemctl start httpd
sudo systemctl enable httpd
# Check if Apache HTTP server is enabled
sudo systemctl is-enabled httpd
#check test page
sudo usermod -a -G apache ec2-user
#checking the groups to verify addition of 'apache'
groups
#Set permissions and ownership for /var/www/ directory
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
#Install addition PHP stuff and restarting services
sudo yum install php-mbstring -y
sudo systemctl restart httpd
sudo systemctl restart php-fpm
#Installing git
cd /var/www/html
sudo yum install git -y
sudo mkdir installation
cd installation
sudo git clone https://github.com/OlamideSolola/MY_STACK_BLOG.git
cp -rf MY_STACK_BLOG/* /var/www/html
#Setting up  wordpress database and configuration
#DB_NAME="wordpressdb"
#DB_USER="admin"
#DB_PASSWORD="Stackinc"
#DB_EMAIL="olamide.solola@gmail.com"
#RDS_INSTANCE="mywordpressinstance.cn4i0ewe6dfj.us-east-1.rds.amazonaws.com"
####
WP_CONFIG=/var/www/html/wp-config.php
#Update wordpress config with db details
sed -i "s/'database_name_here'/'$DB_NAME'/g" $WP_CONFIG
sed -i "s/'username_here'/'$DB_USER_wp'/g" $WP_CONFIG
sed -i "s/'password_here'/'$DB_PASSWORD_wp'/g" $WP_CONFIG
sed -i "s/'rds_instance'/'$RDS_INSTANCE'/g" $WP_CONFIG
#restart apache http server and enable services
sudo systemctl restart httpd
sudo systemctl enable httpd && sudo systemctl enable mariadb
#sudo systemctl status of MySQL and apache HTTP server
sudo systemctl status mariadb
sudo systemctl status httpd
# Restart Apache to make sure all changes take effect
sudo systemctl restart httpd