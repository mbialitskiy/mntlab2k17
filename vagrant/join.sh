#!/bin/bash

UPSTREAM_FILE=/apps/nginx/conf/nodes_ip.conf
while read line; do
    ip=$(echo $line | awk '{print $2}')
    role=$(echo $line | awk '{print $3}')
    grep $ip $UPSTREAM_FILE > /dev/null 2>&1
    if [[ $? -eq 1  &&  $role == "tomcat" ]]; then
        printf "\t server $ip:8080 ; \n">> $UPSTREAM_FILE 
        sudo service nginx reload
    fi
done
