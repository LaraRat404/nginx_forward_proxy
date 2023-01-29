#!/bin/bash
cd /root
wget http://nginx.org/download/nginx-1.22.1.tar.gz
tar xf nginx-1.22.1.tar.gz 
apt install gcc make libssl-dev libpcre3-dev zlib1g-dev libxml2-dev libxslt-dev libgd-dev libgeoip-dev libperl-dev -y
cd nginx-1.22.1
./configure --user=root --group=root --sbin-path=/usr/local/sbin/nginx --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-threads --with-stream --with-stream_ssl_preread_module --with-stream_ssl_module
make && make install
nginx -V
