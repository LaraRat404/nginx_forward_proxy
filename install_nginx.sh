#!/bin/bash
apt install gcc make libssl-dev libpcre3-dev zlib1g-dev  -y
apt install certbot python3-certbot-nginx -y
apt install patch -y
cd /root
wget http://nginx.org/download/nginx-1.22.1.tar.gz
tar xf nginx-1.22.1.tar.gz 
cd nginx-1.22.1
git clone https://github.com/chobits/ngx_http_proxy_connect_module.git
patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch
./configure --user=root --group=root --sbin-path=/sbin/nginx --prefix=/etc/nginx --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-threads --with-stream --with-stream_ssl_preread_module --with-stream_ssl_module --with-http_geoip_module --with-stream_geoip_module --add-module=/root/nginx-1.22.1/ngx_http_proxy_connect_module/patch/proxy_connect.patch 
make && make install
nginx -V
