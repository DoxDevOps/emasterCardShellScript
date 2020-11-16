#!/bin/sh

#The following is the installation guide for E-mastercard
cd ~
echo "Logging into Documents folder"
#cd /var

DIRECTORY="/var/www/emastercard-upgrade-automation"

#The following is for new installation only

#*******************START WITH CHECKING IF THE SYSTEM IS ALREADY INSTALLED ON A SITE********************************
if [ ! -d "$DIRECTORY" ];
then
    mkdir /var/www && chmod 777 /var/www
    echo "$DIRECTORY has been created for fresh emastercard installation"
    cd var/www
    echo "Now cloning https://github.com/HISMalawi/emastercard-upgrade-automation"

    git clone https://github.com/HISMalawi/emastercard-upgrade-automation ~/var/www

    echo "logging into api folder"
    cd $DIRECTORY/api
    cp $DIRECTORY/api/api-config.yml.example $DIRECTORY/api/api-config.yml
    cp $DIRECTORY/api/migration-config.yml.example $DIRECTORY/api/migration-config.yml
    d /var/www/emastercard-upgrade-automation/ | echo 123456 | sudo -S ./setup.py

    sudo docker-compose exec api initialize_database.sh
#*******************ELSE IF THE SYSTEM IS ALREADY UPDATED THEN JUST UPDATE TO THE LATEST TAG********************************
else

      echo "The project is already installed ... NOW preparing to update !!"
      git --git-dir=/var/www/emastercard-upgrade-automation/.git describe
      TAG=$(git  --git-dir=/var/www/emastercard-upgrade-automation/.git describe --tags `git rev-list --tags --max-count=1`)
      echo $TAG $DIRECTORY
      git --git-dir=/var/www/emastercard-upgrade-automation/.git checkout  $TAG -f

      cd /var/www/emastercard-upgrade-automation/ | echo 123456 | sudo -S ./setup.py
      echo " THE SYSTEM HAS BEEN SUCCESSIFULLY UPDATED !! "
fi
