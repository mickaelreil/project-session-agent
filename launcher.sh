#!/bin/bash

agents=4

echo -n "password : "
read -s input
echo ""

for i in $(seq $agents)
do
    
    cp config-save "$i-config"
    cp analyze.sh "$i-analyze.tmp.sh"
    echo $input | ./agent.sh $i
done
