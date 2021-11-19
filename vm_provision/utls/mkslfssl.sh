#!/usr/bin/env bash

# @author Adriano Rosa (http://adrianorosa.com)
# @date: 2014-05-13 09:43
#
# Bash Script to create a new self-signed SSL Certificate
# At the end of creating a new Certificate this script will output a few lines
# to be copied and placed into NGINX site conf
#
# USAGE: this command will ask for the certificate name and number in days it will expire
# $ mkselfssl
#
# OPTIONAL: run the command straightforward
# $ mkselfssl mycertname 365

# Default dir to place the Certificate
DIR_SSL_CERT="/etc/nginx/ssl/cert"
DIR_SSL_KEY="/etc/nginx/ssl/private"

SSLNAME=$1
SSLDAYS=$2

if [ -z $1 ]; then
  printf "Enter the SSL Certificate Name:"
  read SSLNAME
fi

if [ -z $2 ]; then
  printf "How many days the Certificate will be valid:"
  read SSLDAYS
fi

if [[ $SSLDAYS == "" ]]; then
  $SSLDAYS = 365
fi

echo "Creating a new Certificate ..."
# **************   still need additional information for the "-subj" below to be more accurate  ********************
openssl req -new -newkey rsa:2048 -keyout $SSLNAME.key -out $SSLNAME.csr -subj "/"

