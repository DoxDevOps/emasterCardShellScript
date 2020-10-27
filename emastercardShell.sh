#!/bin/sh

#The following is the installation guide for E-mastercard

cd ~
echo "Logging into Documents folder"
#cd /var

DIRECTORY="/var/www/emastercard-upgrade-automation"

#The following is for new installation only

#*******************MAY YOU CHECK THE CODE FROM HERE********************************
if [ ! -d "$DIRECTORY" ];
then
  mkdir $DIRECTORY
    echo "$DIRECTORY has been created for fresh emastercard installation"
    chmod 777 /var/www
    cd var/www
    echo "Now cloning https://github.com/HISMalawi/emastercard-upgrade-automation"

    git clone https://github.com/HISMalawi/emastercard-upgrade-automation ~/var/www

    echo "logging into api folder"
    cd $DIRECTORY/api
    cp api-config.yml.example api-config.yml
    cp migration-config.yml.example migration-config.yml
    ./setup.py

    sudo docker-compose exec api initialize_database.sh
else

echo "the folder is there ...Yyyyy"
  PWD=/var/www/emastercard-upgrade-automation

  		cd ~
  		cd $PWD && ls



fi
