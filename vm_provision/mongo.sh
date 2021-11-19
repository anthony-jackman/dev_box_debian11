#!/usr/bin/env bash
echo "**************************************************************"
echo "            IN MONGODB INSTALL FILE                           "
echo "**************************************************************"


# INTEGRATE MONGODB GPG Key
curl -sSL https://www.mongodb.org/static/pgp/server-5.0.asc  -o mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --import ./mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --export > ./mongoserver_key.gpg
sudo mv mongoserver_key.gpg /etc/apt/trusted.gpg.d/

# ADD mongodb repo
# this might need to be updated when Mongodb is listed in Bullseye repo list
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

# RUN system update
sudo apt-get update

# INSTALL THE MONGODB setup expressed above
# sudo apt-get install mongodb-org
sudo apt-get install -y mongodb-org mongodb-org-database mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools

# START AND ENABLE THE SERVICe
# sudo systemctl enable --now mongodb
sudo systemctl start mongod
echo "Sleeping for 5 seconds"
sleep 3s
sudo systemctl enable mongod

# CHECK STATUS
sudo systemctl status mongod

