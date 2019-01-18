cd /tmp
chefdk_version=3.0.36
chefdk_download_url=https://packages.chef.io/files/stable/chefdk/3.0.36/ubuntu/16.04/chefdk_3.0.36-1_amd64.deb
wget $chefdk_download_url
#--------------------------Installation----------------------------
dpkg -i chefdk_$chefdk_version-1_amd64.deb
if [ $? = 0 ]
then
  rpm -qa *chefdk*
  if [ $? = 0 ]
  then
    cd ~
    chef generate repo chef-repo
    if [ $? = 0 ]
    then    
      mkdir -p ~/chef-repo/.chef
      cp /tmp/ogranization.pem ~/chef-repo/.chef
      cp /tmp/username.pem ~/chef-repo/.chef
      cp /tmp/knife.rb ~/chef-repo/.chef
      knife ssl fetch
      if [ $? = 0 ]
      then    
        echo "chefdk installed and configured successfully"
      else
        echo "Error installing chefdk"
        exit 2
      fi
      cd ~/chef-repo
      verify=`knife client list | wc -l`
      if [ $verify != 0 ]
      then    
        echo "Chefdk installation and configuration verified successfully"
      else
        echo "Error in chefdk installation and verification"
        exit 1
      fi
    else
      echo "Error generating chefrepo directory"
      exit 30
    fi
  else
    echo "Error installing chefdk"
    exit 5
  fi
else
  echo "Package not installed" 
  exit 6
fi
