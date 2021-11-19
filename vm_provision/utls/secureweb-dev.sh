#!/usr/bin/env bash


echo "**************************************************************"
echo "            IN SECUREWEB INSTALL FILE                            "
echo "**************************************************************"
sudo apt-get update
sudo apt-get dist-upgrade -y

#ln -s ~/mkselfssl.sh /usr/local/bin/mkselfssl
# sudo chmod 750 mkselfssl.sh

source /vagrant/vm_provision/utls/mkslfssl.sh devlocalhost 3650
