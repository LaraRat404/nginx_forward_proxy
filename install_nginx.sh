#!/bin/bash
sudo su -
# Next block EOF for AWS only. 
cat <<EOF >> /etc/apt/sources.list
deb http://deb.debian.org/debian/ bullseye main
deb-src http://deb.debian.org/debian/ bullseye main
deb http://deb.debian.org/debian-security bullseye-security main
deb-src http://deb.debian.org/debian-security bullseye-security main
deb http://deb.debian.org/debian/ bullseye-updates main
deb-src http://deb.debian.org/debian/ bullseye-updates main
EOF
apt update -y
apt upgrade -y
# End of block for AWS
apt-get install git -y
apt-get install gcc make libssl-dev libpcre3-dev zlib1g-dev libgeoip-dev -y
apt-get install patch -y
cd /root
wget http://nginx.org/download/nginx-1.22.1.tar.gz
tar xf nginx-1.22.1.tar.gz 
cd nginx-1.22.1
git clone https://github.com/chobits/ngx_http_proxy_connect_module.git
patch -p1 < ./ngx_http_proxy_connect_module/patch/proxy_connect_rewrite_102101.patch
./configure --user=root --group=root --sbin-path=/sbin/nginx --prefix=/etc/nginx --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-threads --with-stream --with-stream_ssl_preread_module --with-stream_ssl_module --with-http_geoip_module --with-stream_geoip_module --add-module=/root/nginx-1.22.1/ngx_http_proxy_connect_module 
make
make install
# Next string save nginx.conf backup.
cp /etc/nginx/conf/nginx.conf /etc/nginx/conf/nginx.conf.bak
# You can use www o www-data user:group, worker_processes = processosr cores.
cat <<\EOF > /etc/nginx/conf/nginx.conf
user  root root;
worker_processes  2;
events {
    worker_connections  1024;
}
http {
        include       mime.types;
        default_type  application/octet-stream;
        sendfile        on;
        keepalive_timeout  65;
        server {
                listen 8888;
                resolver 8.8.8.8;
                proxy_connect;
                proxy_connect_allow     443;
                proxy_connect_connect_timeout 20s;
                proxy_connect_read_timeout 20s;
                proxy_connect_send_timeout 20s;
                }
}
EOF
nginx
