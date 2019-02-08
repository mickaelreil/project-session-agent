#!/bin/bash

#PASSWD
id=$1
log_f="log.tmp"
center="mickael@172.16.131.74"
pid=$(ps -u | grep -e "agent.sh $id | agent.tmp.sh $id" | sed -n 1p | cut -d " " -f 4)

if [ "$PASS" = "" ]
then
    echo -n "password : "
    read -s input
    echo ""
    PASS=$input
    sed -e 's/^#PASSWD/PASS="'$PASS'"/g' agent.sh > agent.tmp.sh
fi


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
scp -o StrictHostKeyChecking=no $host:agent.tmp.sh $remote:agent.tmp.sh;
scp -o StrictHostKeyChecking=no $host:analyze.tmp.sh $remote:analyze.tmp.sh;
chmod u+x agent.tmp.sh;
chmod u+x analyze.tmp.sh;
./analyze.tmp.sh $log_f;
scp -o StrictHostKeyChecking=no $log_f $center:log/log-$remote;
rm $log_f;
(./agent.tmp.sh $id &);"
fi

rm agent.tmp.sh 2> /dev/null
rm config 2> /dev/null
rm analyze.tmp.sh 2> /dev/null
exit
