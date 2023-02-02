#!/bin/bash
apt install gcc make libssl-dev libpcre3-dev zlib1g-dev  -y
apt install certbot python3-certbot-nginx -y
cd /root
wget http://nginx.org/download/nginx-1.22.1
tar xf nginx-1.22.1.tar.gz 
cd nginx-1.22.1
./configure --user=root --group=root --sbin-path=/usr/local/sbin/nginx --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-threads --with-stream --with-stream_ssl_preread_module --with-stream_ssl_module 
make && make install
nginx -V
