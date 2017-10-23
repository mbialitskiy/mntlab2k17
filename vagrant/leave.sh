#!/bin/bash

UPSTREAM_FILE=/apps/nginx/conf/nodes_ip.conf
while read line; do
    ip=$(echo $line | awk '{print $2}')
    grep $ip $UPSTREAM_FILE > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        sed -i "/${ip}/d" $UPSTREAM_FILE 
        sudo service nginx reload
    fi
done
