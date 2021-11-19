#!/usr/bin/env bash

echo "**************************************************************"
echo "            IN GIT INSTALL FILE                               "
echo "**************************************************************"
sudo apt-get update
sudo apt-get install -y libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev tcl gettext xmlto docbook2x

# GET THE TAR BALL
mkdir-p /usr/src
cd /usr/src
wget https://github.com/git/git/archive/v2.33.1.tar.gz && tar xzvf v2.33.1.tar.gz

# BUILD GIT
cd git-2.33.1/
make configure
./configure --prefix=/usr
#  **************************************************************
#      PROFILE=BUILD is a very lengthy process. Only needs to
#      be run if OS version has bumped or GIT SCM version
#      has been bumped.
#      If this GIT version has been tested on the installed OS
#      version, advisable to build GIT without the attribute.
#  **************************************************************
# make prefix=/usr PROFILE=BUILD install install-doc install-html install-info
# WITHOUT ALL THE TESTING
# make prefix=/usr install install-doc install-html install-info
# BARE MINIMUM install below
sudo make prefix=/usr install

# Check GIT and its installed version
git --version



#  *********************************************
#  *************  THE EASY WAY   ***************
#  *********************************************
#  sudo apt-get update
#  sudo apt-get install -y git

#  git --version

#  git config --global user.name "Anthony Jackman"
#  git config --global user.email "anthony.jackman@serco-na.com"