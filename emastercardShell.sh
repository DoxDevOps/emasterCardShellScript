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
    mkdir /var/www && chmod 777 /var/www
    mkdir $DIRECTORY
    echo "$DIRECTORY has been created for fresh emastercard installation"
    cd var/www
    echo "Now cloning https://github.com/HISMalawi/emastercard-upgrade-automation"

    git clone https://github.com/HISMalawi/emastercard-upgrade-automation ~/var/www

    echo "logging into api folder"
    cd $DIRECTORY/api
    cp $DIRECTORY/api/api-config.yml.example $DIRECTORY/api/api-config.yml
    cp $DIRECTORY/api/migration-config.yml.example $DIRECTORY/api/migration-config.yml
    ./setup.py  $DIRECTORY

    sudo docker-compose exec api initialize_database.sh
else

echo "The project is already installed ... NOW preparing to update !!"
git describe --tags $DIRECTORY
      TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
      echo $TAG $DIRECTORY
      git checkout $TAG -b latest $DIRECTORY
      ./setup.py  $DIRECTORY
fi
