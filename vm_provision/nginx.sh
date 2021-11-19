#!/usr/bin/env bash

echo "**************************************************************"
echo "            IN NGINX INSTALL FILE                             "
echo "**************************************************************"

sudo apt-get update
sudo apt-get upgrade -y

sudo apt-get install -y nginx
sudo systemctl enable --now nginx
sudo systemctl status nginx