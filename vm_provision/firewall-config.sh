#!/usr/bin/env bash
echo "**************************************************************"
echo "        PROJECT SPECIFIC FIREWALL CONFIG - DEV MODE           "
echo "**************************************************************"

# CREATE UFW PROFILE FOR NGINX

cd /etc/ufw/applications.d
cat >> mongodb << EOF
[MongoDB]
title=Database Server (MongoDB)
description=Small, but very powerful and efficient database server
ports=27017/tcp
EOF
cat >> node1 << EOF
[NODEJS1]
title=NodeJS API #1 (NodeJS)
description=Very powerful API for interacting with database server
ports=3030/tcp
EOF
cat >> node2 << EOF
[NODEJS2]
title=NodeJS API #2 (NodeJS)
description=Very powerful API for interacting with database server
ports=3001/tcp
EOF

# sudo ufw app list

echo "y" | sudo ufw enable
# sudo ufw --force enable

# Initial security best practice
sudo ufw default allow outgoing
sudo ufw default deny incoming

echo "**************************************************************"
echo "     ******   APP DEVELOPMENT MODE ONLY    *********          "
echo "**************************************************************"
sudo ufw allow OpenSSH
# sudo ufw allow WWW
# sudo ufw allow 'WWW Secured'
sudo ufw allow MongoDB
sudo ufw allow NODEJS1
# sudo ufw allow NODEJS2


sudo ufw reload
sudo ufw status verbose