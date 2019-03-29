#!/bin/bash

agents=5
ipbyagent=0
hostname="mickael"
lcount=$(cat config-save | wc -w)

cp config-save config.tmp

echo -n "password : "
read -s input
echo ""

if [ $agents -lt $lcount ]
then
    ipbyagent=$((($lcount)/($agents)))
else
    ipbyagent=1
fi

for i in $(seq $agents)
do
    cp analyze.sh "$i-analyze.tmp.sh"
    ips=$(cat config.tmp | wc -w)
    if [ $i -eq $agents ] && [ $ips -gt $ipbyagent ]
    then
	ipbyagent=$(($ipbyagent+1))
    fi
    for z in $(seq $ipbyagent)
    do
	ips=$(cat config.tmp | wc -w)
	if [ $ips -ne 0 ]
	then
	    if [ $ips -gt 1 ]
	    then
		rline=$((($RANDOM%($ips))+1))
	    else
		rline=1
	    fi	
	    #echo "ips=$ips;rline=$rline"
	    ip=$(sed -n $rline"p" config.tmp)
	    sed -i $rline"d" config.tmp
	    echo "$hostname@$ip"
	    #echo "$hostname@$ip" >> "$i-config.tmp"
	fi	
    done
    #(./agent.sh $i $input $hostname > /dev/null) &
    pids[${i}]=$!
    echo "Launching agent $i at $(date +'%H:%M:%S') PID=$!"
done

echo "Waiting for processes to finish..."

for pid in ${pids[*]}
do
    wait $pid
done

rm config.tmp
