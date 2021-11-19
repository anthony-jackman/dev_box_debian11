#!/usr/bin/env bash

echo "**************************************************************"
echo "            IN NGINX INSTALL FILE                             "
echo "**************************************************************"

sudo apt-get update
sudo apt-get upgrade -y

# GIT and TREE NEEDS TO BE INSTALLED BEFORE THIS

# CREATE AND CHANGE TO source code directory
mkdir -p /usr/src
cd /usr/src
# DOWNLOAD MAINLINE SOURCE CODE and UNPACK
wget https://nginx.org/download/nginx-1.21.3.tar.gz && tar zxvf nginx-1.21.3.tar.gz
# DOWNLOAD NGINX DEPS
wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz && tar xzvf pcre-8.43.tar.gz
wget https://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz
wget https://www.openssl.org/source/openssl-3.0.0.tar.gz && tar xzvf openssl-3.0.0.tar.gz
# DOWNLOAD AND INSTALL OPTIONAL DEPS
sudo apt-get install -y perl libperl-dev libgd3 libgd-dev libgeoip1 libgeoip-dev geoip-bin libxml2 libxml2-dev libxslt1.1 libxslt1-dev
# CLEAN UP TAR BALLS
rm -rf *.tar.gz
# CHANGE DIRECTORY
cd nginx-1.21.3
# LIST DIRECTORIES AND FILES THAT COMPOSE NGINX SOURCE
tree -L 2 .
# COPY THE MANUAL PAGE
sudo cp nginx-1.21.3/man/nginx.8 /usr/share/man/man8
sudo gzip /usr/share/man/man8/nginx.8
ls /usr/share/man/man8/ | grep nginx.8.gz
# CHECK TO MAKE SURE MAN PAGE IS WORKING
man nginx
# CONFIGURE NGINX
./configure --prefix=/etc/nginx \
            --sbin-path=/usr/sbin/nginx \
            --modules-path=/usr/lib/nginx/modules \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=nginx \
            --group=nginx \
            --build=Debian \
            --builddir=nginx-1.21.3 \
            --with-select_module \
            --with-poll_module \
            --with-threads \
            --with-file-aio \
            --with-http_ssl_module \
            --with-http_v2_module \
            --with-http_realip_module \
            --with-http_addition_module \
            --with-http_xslt_module=dynamic \
            --with-http_image_filter_module=dynamic \
            --with-http_geoip_module=dynamic \
            --with-http_sub_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_mp4_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_auth_request_module \
            --with-http_random_index_module \
            --with-http_secure_link_module \
            --with-http_degradation_module \
            --with-http_slice_module \
            --with-http_stub_status_module \
            --with-http_perl_module=dynamic \
            --with-perl_modules_path=/usr/share/perl/5.26.1 \
            --with-perl=/usr/bin/perl \
            --http-log-path=/var/log/nginx/access.log \
            --http-client-body-temp-path=/var/cache/nginx/client_body_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-mail=dynamic \
            --with-mail_ssl_module \
            --with-stream=dynamic \
            --with-stream_ssl_module \
            --with-stream_realip_module \
            --with-stream_geoip_module=dynamic \
            --with-stream_ssl_preread_module \
            --with-compat \
            --with-pcre=../pcre-8.43 \
            --with-pcre-jit \
            --with-zlib=../zlib-1.2.11 \
            --with-openssl=../openssl-3.0.0 \
            --with-openssl-opt=no-nextprotoneg \
            --with-debug
# COMPILE NGINX
make
# INSTALL NGINX
sudo make install
# CHANGE TO HOME DIRECTORY
cd ~
# INSTALL A SYMLINK
sudo ln -s /usr/lib/nginx/modules /etc/nginx/modules

# PRINT NGINX version/compiler/configure scripts params
sudo nginx -v

# CREATE NGINX GROUP
sudo adduser --system --home /sbin/nologin --shell /bin/false --no-create-home --disabled-login --disabled-password --gecos "nginx user" --group nginx
# CHECK TO MAKE SURE IT WAS CREATED
sudo tail -n 1 /etc/passwd /etc/group /etc/shadow

# TEST SETUP
# this might throw error for the cache directories fixed in line below
sudo nginx -t
# Create NGINX cache directories and set proper permissions
sudo mkdir -p /var/cache/nginx/{client_body_temp,fastcgi_temp,proxy_temp,scgi_temp,uwsgi_temp}
sudo chmod 700 /var/cache/nginx/*
sudo chown nginx:root /var/cache/nginx/*
# RETEST FOR SETUP ERRORS
sudo nginx -t

# CREATE SYSTEMD file
#sudo mkdir -p /lib/systemd/system
cd /lib/systemd/system
# SETUP ACTIONS OF NGINX SYSTEMD
cat >> nginx.service << EOF
[Unit]
Description=nginx - high performance web server
Documentation=https://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID

[Install]
WantedBy=multi-user.target
EOF

# ENABLE NGINX TO START ON BOOT AND START IMMEDIATELY
sudo systemctl start nginx
sudo systemctl enable nginx
# CHECK FOR ENABLED
sudo systemctl status nginx

# REMOVE THE BACKUP FILES
sudo rm /etc/nginx/*.default

# CREATE SOME OPERATIONAL DIRECTORIES
sudo mkdir -p /etc/nginx/{conf.d,snippets,sites-available,sites-enabled}

# CHANGE PERMISSIONS OF LOGS
sudo chmod 640 /var/log/nginx/*
sudo chown nginx:adm /var/log/nginx/access.log /var/log/nginx/error.log

# CREATE A LOG ROTATION RULE FILE
sudo mkdir -p /etc/logrotate.d
cd /etc/logrotate.d
# FILL THE FILE WITH RULES
cat >> nginx << EOF
/var/log/nginx/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 640 nginx adm
    sharedscripts
    postrotate
            if [ -f /var/run/nginx.pid ]; then
                    kill -USR1 `cat /var/run/nginx.pid`
            fi
    endscript
}
EOF

# FINAL CLEAN UP
cd /usr/src
rm -rf nginx-1.21.3/ openssl-3.0.0/ zlib-1.2.11/ pcre-8.43/
