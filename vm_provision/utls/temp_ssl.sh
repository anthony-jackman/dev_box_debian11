# USE THIS FOR TESTING AND DEVELOPMENT
touch /tmp/openssl.cnf
echo "[req]
default_bits = 2048
default_keyfile = privkey.pem
distinguished_name = req_distinguished_name
x509_extensions = v3_ca

[req_distinguished_name]
countryName_default = US
stateOrProvinceName_default = Minnesota
localityName_default = Albertville
organizationName_default = EnergeticPixels
organizationalUnitName_default = Development
commonName_default = localhost
commonName_max = 64

[v3_ca]
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
# Support subdomains
#DNS.2 = *.domain.local" > /tmp/openssl.cnf

# ***********************     came from this link due to cnf file issues **************************************
# ***       https://github.com/openssl/openssl/issues/3536#issuecomment-519937297          ********************
# *************************************************************************************************************
openssl req -x509 -nodes -days 3650 -newkey rsa:1024 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt -subj "/"

# sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt -config /tmp/openssl.cnf

cat <<-CONF > /etc/nginx/sites-available/default
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	listen 443 ssl default_server;
	listen [::]:443 ssl default_server;

	ssl_certificate /etc/ssl/certs/localhost.crt;
	ssl_certificate_key /etc/ssl/private/localhost.key;

	root /var/www/html;
	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		try_files $uri $uri/ =404;
	}
}
CONF


# cat /etc/nginx/sites-available/default

#sudo openssl genrsa 2048 > server.key
#sudo openssl req -new -key server.key -subj "/C=US/ST=Minnesota/L=Albertville/O=Personal/OU=Local Machine/CN=localhost" > server.csr
##sudo openssl x509 -days 3650 -signkey server.key < server.csr > server.crt
#mv server.* /etc/nginx/conf.d/
#cat <<-CONF > /etc/nginx/conf.d/ssl.conf
##server {
#    listen       443  default ssl;
#    ssl on;
#    ssl_certificate     /etc/nginx/conf.d/server.crt;
 #   ssl_certificate_key /etc/nginx/conf.d/server.key;
 #   server_name  localhost;
#}
#CONF

sudo nginx -t


#sudo systemctl restart nginx