#!/bin/bash
sudo -i
mkdir /apps/nginx -p
nginx_link="http://nginx.org/download/nginx-1.13.6.tar.gz"
nginx_file="nginx-1.13.6.tar.gz"
nginx_folder="nginx-1.13.6"
nginx_configure="--prefix=/apps/nginx --without-http_rewrite_module --without-http_gzip_module"

cd /apps/nginx
wget -q $nginx_link
tar xvzf ./$nginx_file && rm -rf ./$nginx_file
cd ./$nginx_folder
./configure $nginx_configure && make && make install
cd /apps/nginx
rm -rf ./$nginx_folder
cp /vagrant/nginx.conf /apps/nginx/conf/nginx.conf -rf
cp /vagrant/nodes_ip.conf /apps/nginx/conf/nodes_ip.conf
yum install -y avahi nss-mdns  unzip
systemctl start avahi-daemon
systemctl enable avahi-daemon
mkdir /apps/serf
cd /apps/serf 
wget -qO ./serf.zip https://releases.hashicorp.com/serf/0.8.1/serf_0.8.1_linux_amd64.zip
unzip ./serf.zip
cp /vagrant/nginx.json /apps/serf/nginx.json
cp /vagrant/join.sh /apps/serf/
chmod +x ./join.sh
cp /vagrant/leave.sh /apps/serf/
chmod +x ./leave.sh
cp /vagrant/serf.service /etc/systemd/system/serf.service
cp /vagrant/nginx.service /etc/systemd/system/nginx.service
systemctl daemon-reload
systemctl enable nginx.service
systemctl enable serf.service
service nginx start
service serf start
