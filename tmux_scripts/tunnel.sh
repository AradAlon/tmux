#!/bin/bash

ip=$(ps o cmd | grep '^ssh.*27017:127.0.0.1:27017' | cut -d '@' -f 2 | cut -d ' ' -f1)
docker=$(docker ps --format "{{.Image}}")

echo 'None'
if [[ $docker ]];then
    echo -en 'docker'
fi
if [[ $ip ]]; then
    echo -e $ip
fi
