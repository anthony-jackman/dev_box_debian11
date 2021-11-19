openssl -x509 -req -nodes -days $SSLDAYS -in $SSLNAME.csr -signkey $SSLNAME.key -out $SSLNAME.crt
echo "*************    MADE NEW CERT     **********************"

# Make directory to place SSL Certificate if it doesn't exists
if [[ ! -d $DIR_SSL_KEY ]]; then
  sudo mkdir -p $DIR_SSL_KEY
  echo "************   MADE KEY FOLDER   *************"
fi

if [[ ! -d $DIR_SSL_CERT ]]; then
  sudo mkdir -p $DIR_SSL_CERT
  echo "************   MADE CERT FOLDER   *************"
fi

# Place SSL Certificate within defined path
# sudo cp $SSLNAME.key $DIR_SSL_KEY/$SSLNAME.key
sudo mv $SSLNAME.crt $DIR_SSL_CERT/$SSLNAME.crt

# Print output for Nginx site config
printf "+-------------------------------
+ SSL Certificate has been created.
+ Here is the NGINX Config for $SSLNAME
+ Copy it into your nginx config file
+-------------------------------\n\n
ssl_certificate      $DIR_SSL_CERT/$SSLNAME.crt;
ssl_certificate_key  $DIR_SSL_KEY/$SSLNAME.key;
ssl_session_cache shared:SSL:1m;
ssl_session_timeout  5m;\n\n"