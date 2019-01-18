#!/bin/bash

CHEF_SERVER_VERSION=12.15.8
CHEF_SERVER_DOWNLOAD_URL=https://packages.chef.io/files/stable/chef-server/12.15.8/ubuntu/14.04/chef-server-core_12.15.8-1_amd64.deb

sysctl net.ipv6.conf.lo.disable_ipv6=0

apt-get update
apt-get install -y wget

wget  $CHEF_SERVER_DOWNLOAD_URL
dpkg -i chef-server-core_$CHEF_SERVER_VERSION-1_amd64.deb

if [$? = 0] 
then
 echo "Chef Server installed"
 (/opt/opscode/embedded/bin/runsvdir-start &) && chef-server-ctl reconfigure
 # Create a default admin user
 chef-server-ctl user-create admin admin admin admin@example.com 'admin123' --filename /etc/opscode/admin.pem

 #Create organization
 chef-server-ctl org-create gslab “GS Lab, Pune” --filename ~/chef-validator.pem

 #Add user to the organization
 chef-server-ctl org-user-add gslab admin --admin
 
 #Copying files
 cp /etc/opscode/admin.pem /var/nfsshare
 cp ~/chef-validator.pem /var/nfsshare
else
 echo "Chef server installation failed"
 exit 1
fi
