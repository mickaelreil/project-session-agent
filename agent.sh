#!/bin/bash

id=$1
PASS=$2
hostname=$3
log_f="$id-log.tmp"
ip_center="172.16.131.59"
center="$hostname@$ip_center"
config="$id-config.tmp"
agent="$id-agent.tmp.sh"
analyze="$id-analyze.tmp.sh"
lcount=$(cat $config | wc -l)

#Suppression de fichier temporaire
if [ $lcount -eq 0 ]
then
    rm $agent 2> /dev/null
    rm $config 2> /dev/null
    rm $analyze 2> /dev/null
    exit
fi


#Choix aléatoire d'une ligne
rline=$((($RANDOM%($lcount))+1))

#Affectation du mot de passe 
if [ "$PASS" = "" ]
then
    echo -n "password : "
    read -s input
    echo ""
    PASS=$input
    sed -e 's/^PASS=/PASS="'$PASS'"/g' $0 > $agent
fi

#Création d'un fichier agent temporaire (sur la machine centrale)
if [ $(echo $0 | cut -d "/" -f 2) = "agent.sh" ]
then
   cp $0 $agent
fi

#addresse ip de l'hôte actuel
host=$USER"@"$(ip a | grep "inet " | tail -1 | cut -d " " -f 6 | cut -d "/" -f 1)

#adresse ip selon une ligne aléatoire
remote=$(sed -n $rline"p" $config)

if [ "$remote" != "" ]
then
    echo "From : "$host
    echo "To : "$remote
    sed -i $rline"d" $config
    ssh -o BatchMode=yes $remote 'exit' 2> /dev/null
    if [ $? -ne 0 ]
    then
	sshpass -p $PASS ssh-copy-id -o StrictHostKeyChecking=no $remote
    fi
    ssh $remote "
sshpass -p $PASS ssh-copy-id -o StrictHostKeyChecking=no $host 2> /dev/null;
sshpass -p $PASS ssh-copy-id -o StrictHostKeyChecking=no $center 2> /dev/null;
scp -o StrictHostKeyChecking=no $host:$agent $remote:$agent;
scp -o StrictHostKeyChecking=no $host:$analyze $remote:$analyze;
scp -o StrictHostKeyChecking=no $host:$config $remote:$config;
chmod u+x $agent;
chmod u+x $analyze;
./$analyze $log_f $id;
scp -o StrictHostKeyChecking=no $log_f $center:log/log-$remote;
rm $log_f;
./$agent $id $PASS $hostname > /dev/null;
exit;"
fi    
rm $config 2> /dev/null
rm $agent 2> /dev/null
rm $analyze 2> /dev/null
exit
