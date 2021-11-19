#!/usr/bin/env bash

echo "**************************************************************"
echo "            IN basic INSTALL FILE                             "
echo "**************************************************************"

sudo apt-get update
sudo apt-get dist-upgrade -y

# SETUP TIMEZONE
sudo ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

sudo apt-get install -y curl gcc dkms build-essential software-properties-common dh-autoreconf tree vim libz-dev asciidoc gnupg2

