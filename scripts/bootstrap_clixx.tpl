#!/bin/bash -x
exec > >(tee /var/log/userdata.log) 2>&1
sudo yum update -y

# EBS
sudo fdisk /dev/sdb<<EEOF
n
p
1


p
w
EEOF
sudo fdisk /dev/sdc<<EEOF
n
p
1


p
w
EEOF
sudo fdisk /dev/sdd<<EEOF
n
p
1


p
w
EEOF
sudo fdisk /dev/sde<<EEOF
n
p
1


p
w
EEOF
sudo fdisk /dev/sdf<<EEOF
n
p
1


p
w
EEOF

sudo pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1


sudo vgcreate stack_vg /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

sudo lvcreate -L 5G -n Lv_u01 stack_vg
 
sudo lvcreate -L 5G -n Lv_u02 stack_vg

sudo lvcreate -L 5G -n Lv_u03 stack_vg

sudo lvcreate -L 5G -n Lv_u04 stack_vg

sudo lvcreate -L 5G -n Lv_backup stack_vg


sudo mkfs.ext4 /dev/stack_vg/Lv_u01

sudo mkfs.ext4 /dev/stack_vg/Lv_u02

sudo mkfs.ext4 /dev/stack_vg/Lv_u03

sudo mkfs.ext4 /dev/stack_vg/Lv_u04

sudo mkfs.ext4 /dev/stack_vg/Lv_backup


sudo mkdir /u01
sudo mkdir /u02
sudo mkdir /u03
sudo mkdir /u04
sudo mkdir /backup


sudo mount /dev/stack_vg/Lv_u01 /u01
sudo mount /dev/stack_vg/Lv_u02 /u02
sudo mount /dev/stack_vg/Lv_u03 /u03
sudo mount /dev/stack_vg/Lv_u04 /u04
sudo mount /dev/stack_vg/Lv_backup /backup

echo "/dev/mapper/stack_vg-Lv_u01 /u01 ext4 defaults 1 2" >> "/etc/fstab"
echo "/dev/mapper/stack_vg-Lv_u02 /u02 ext4 defaults 1 2" >> "/etc/fstab"
echo "/dev/mapper/stack_vg-Lv_u03 /u03 ext4 defaults 1 2" >> "/etc/fstab"
echo "/dev/mapper/stack_vg-Lv_u04 /u04 ext4 defaults 1 2" >> "/etc/fstab"
echo "/dev/mapper/stack_vg-Lv_backup /backup ext4 defaults 1 2" >> "/etc/fstab"


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


##Install the needed packages and enable the services(MariaDb, Apache)

sudo yum install git -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl is-enabled httpd
 
##Add ec2-user to Apache group and grant permissions to /var/www
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd /var/www/html
 
 
git clone https://github.com/stackitgit/CliXX_Retail_Repository.git
cp -r CliXX_Retail_Repository/* /var/www/html

 
## Allow wordpress to use Permalinks
sudo sed -i '151s/None/All/' /etc/httpd/conf/httpd.conf
 
##Grant file ownership of /var/www & its contents to apache user
sudo chown -R apache /var/www
 
##Grant group ownership of /var/www & contents to apache group
sudo chgrp -R apache /var/www
 
##Change directory permissions of /var/www & its subdir to add group write 
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
 
##Recursively change file permission of /var/www & subdir to add group write perm
sudo find /var/www -type f -exec sudo chmod 0664 {} \;

# Replace DB host in wp config file
sed -i "s/'wordpress-db.cc5iigzknvxd.us-east-1.rds.amazonaws.com'/'${DB_HOST}'/g" /var/www/html/wp-config.php

mysql -u ${DB_USER} -p${DB_PASSWORD} -h ${DB_HOST} -D ${DB_NAME}<<EOF
Update wp_options SET option_value="${LB_DNS}" WHERE option_value like '%elb%';
EOF



##Restart Apache
sudo systemctl restart httpd
sudo service httpd restart
 
##Enable httpd 
sudo systemctl enable httpd 
sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=200 net.ipv4.tcp_keepalive_intvl=200 net.ipv4.tcp_keepalive_probes=5




