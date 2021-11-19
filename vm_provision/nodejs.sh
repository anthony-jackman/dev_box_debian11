#!/usr/bin/env bash

echo "**************************************************************"
echo "            IN NODEJS INSTALL FILE                            "
echo "**************************************************************"
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
# sudo apt-cache policy nodejs
sudo apt-get install -y nodejs

node -v
npm -v