#!/bin/bash
tomcat_link="http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz"
tomcat_file="apache-tomcat-8.5.23.tar.gz"
tomcat_folder="apache-tomcat-8.5.23"

sudo -i
yum install -y -q java avahi nss-mdns unzip
systemctl start avahi-daemon && systemctl enable avahi-daemon
mkdir /apps/tomcat -p
cd /apps/tomcat
wget -q $tomcat_link
tar xvzf ./$tomcat_file
cd ./$tomcat_folder
cp /vagrant/clusterjsp.war /apps/tomcat/$tomcat_folder/webapps/cluster.war
mkdir /apps/serf
cd /apps/serf 
wget -qO ./serf.zip https://releases.hashicorp.com/serf/0.8.1/serf_0.8.1_linux_amd64.zip
unzip ./serf.zip
cp /vagrant/tomcat.json /apps/serf/tomcat.json
cp /vagrant/serf.service /etc/systemd/system/serf.service
cp /vagrant/tomcat.service /etc/systemd/system/tomcat.service
systemctl daemon-reload
systemctl start tomcat.service
systemctl enable tomcat.service
systemctl start serf.service
systemctl enable serf.service
