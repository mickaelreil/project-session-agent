#!/bin/bash

PASS="agent123"

id=$1

center="mickael@172.16.131.74"

host=$USER"@"$(ip a | grep "inet " | tail -1 | cut -d " " -f 6 | cut -d "/" -f 1)

remote=$(sed -n "1p" config)

if [ "$remote" != "" ]
   then
       echo "From : "$host
       echo "To : "$remote
       sed -i "1d" config
       sshpass -p $PASS ssh-copy-id -o StrictHostKeyChecking=no $remote 2> /dev/null
       ssh $remote "
sshpass -p $PASS ssh-copy-id -o StrictHostKeyChecking=no $host 2> /dev/null;
sshpass -p $PASS ssh-copy-id -o StrictHostKeyChecking=no $center 2> /dev/null;

scp -o StrictHostKeyChecking=no $host:config $remote:config;
scp -o StrictHostKeyChecking=no $host:agent.sh $remote:agent.sh;
scp -o StrictHostKeyChecking=no $host:analyze.sh $remote:analyze.sh;
./analyze.sh;
scp -o StrictHostKeyChecking=no log $center:log/log-$remote;
rm log;
./agent.sh $id;"
fi
