#!/usr/bin/env bash


echo "**************************************************************"
echo "            IN SECUREWEB INSTALL FILE                            "
echo "**************************************************************"
sudo apt-get update
sudo apt-get dist-upgrade -y

# Dependancies!!
sudo apt-get install -y python3-acme python3-certbot python3-mock python3-openssl python3-pkg-resources python3-pyparsing python3-zope.interface
# USE THIS FOR PRODUCTION
sudo apt-get install -y python3-certbot-nginx

# ************************************************************************************
#                still needs to be finished                                          *
# ************************************************************************************


sudo systemctl restart nginx