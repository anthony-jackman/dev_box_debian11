#!/usr/bin/env bash
echo "**************************************************************"
echo "            IN UFW INSTALL FILE                             "
echo "**************************************************************"

sudo apt-get install -y ufw

echo "initial on/off config of ufw is: "
sudo ufw status