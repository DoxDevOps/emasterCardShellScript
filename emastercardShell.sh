#!/bin/sh
 
# The following is the installation guide for eMC
# The script considers two situations - 1. a site that already has eMC, 2. a new site without eMC

# Make sure you are on ~ 
cd ~
echo "Logging into Documents folder"

# Define dir where the system sits
DIRECTORY="/var/www/emastercard-upgrade-automation"

# FOR NEW INSTALLATION

# Check if system dir (as defined above) exists
# The assumption is that if it doesn't exist, then that is a new site
if [ ! -d "$DIRECTORY" ];
then
    # Create www /dir and grant relevant privilages 
    mkdir /var/www && chmod 777 /var/www
    
    # Create the dir where the system sits
    mkdir $DIRECTORY
    echo "$DIRECTORY has been created for fresh emastercard installation"
    
    # Move into /www and clone the relevant eMC repo
    cd var/www
    echo "Now cloning https://github.com/HISMalawi/emastercard-upgrade-automation"
    git clone https://github.com/HISMalawi/emastercard-upgrade-automation ~/var/www
    
    # in /api dir change the api-config.yml.example to api-config.yml
    # in /api dir change migration-config.yml.example to migration-config.yml
    echo "logging into api folder"
    cd $DIRECTORY/api
    cp $DIRECTORY/api/api-config.yml.example $DIRECTORY/api/api-config.yml
    cp $DIRECTORY/api/migration-config.yml.example $DIRECTORY/api/migration-config.yml
    d /var/www/emastercard-upgrade-automation/ | echo 123456 | sudo -S ./setup.py

    sudo docker-compose exec api initialize_database.sh
    
# FOR EXISTING INSTALLATION

else
      # Check out the latest TAG  
      echo "The project is already installed ... NOW preparing to update!!"
      git --git-dir=/var/www/emastercard-upgrade-automation/.git describe
      TAG=$(git  --git-dir=/var/www/emastercard-upgrade-automation/.git describe --tags `git rev-list --tags --max-count=1`)
      echo $TAG $DIRECTORY
      git --git-dir=/var/www/emastercard-upgrade-automation/.git checkout  $TAG -f
      cd /var/www/emastercard-upgrade-automation/ | echo 123456 | sudo -S ./setup.py
      echo "The system has successfully been updated."
fi
