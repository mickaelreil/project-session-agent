#!/bin/bash

agents=1

cp config-save config
cp analyze.sh analyze.tmp.sh

echo -n "password : "
read -s input
echo ""

for i in $(seq $agents)
do
    echo $input | ./agent.sh $i
done
