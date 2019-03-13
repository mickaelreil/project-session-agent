#!/bin/bash

#PASSWD
id=$1
log_f="$id-log.tmp"
center="mickael@192.168.204.141"
config="$id-config"
agent="$id-agent.tmp.sh"
analyze="$id-analyze.tmp.sh"
lcount=$(wc -l $config | awk '{print $1}')
rline=$((($RANDOM%($lcount+1))+1))

if [ "$PASS" = "" ]
then
    echo -n "password : "
    read -s input
    echo ""
    PASS=$input
    sed -e 's/^#PASSWD/PASS="'$PASS'"/g' agent.sh > $agent
fi


host=$USER"@"$(ip a | grep "inet " | tail -1 | cut -d " " -f 6 | cut -d "/" -f 1)

remote=$(sed -n $rline"p" $config)

if [ "$remote" != "" ]
then
    echo "From : "$host
    echo "To : "$remote
    sed -i $rline"d" $config
    sshpass -p $PASS ssh-copy-id -o StrictHostKeyChecking=no $remote 2> /dev/null
    ssh $remote "
sshpass -p $PASS ssh-copy-id -o StrictHostKeyChecking=no $host 2> /dev/null;
sshpass -p $PASS ssh-copy-id -o StrictHostKeyChecking=no $center 2> /dev/null;
scp -o StrictHostKeyChecking=no $host:$config $remote:$config;
scp -o StrictHostKeyChecking=no $host:$agent $remote:$agent;
scp -o StrictHostKeyChecking=no $host:$analyze $remote:$analyze;
chmod u+x $agent;
chmod u+x $analyze;
./$analyze $log_f;
scp -o StrictHostKeyChecking=no $log_f $center:log/log-$remote;
rm $log_f;
./$agent $id > /dev/null;
exit;"
fi
rm $config 2> /dev/null
rm $agent 2> /dev/null
rm $analyze 2> /dev/null
exit
