#!/usr/bin/env bash

echo "**************************************************************"
echo "            IN GIT INSTALL FILE                               "
echo "**************************************************************"
sudo apt-get update
sudo apt-get install -y git

echo "GIT VERSION INSTALLED: "
git --version

git config --global user.name "Anthony Jackman"
git config --global user.email "anthony.jackman@serco-na.com"