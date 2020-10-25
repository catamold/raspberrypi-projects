#!/bin/bash

for (( i=1; i <= 12; i++ ))
do
    date_time=$(date +'%Y-%m-%d %H:%M:%S')

    temperature=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')

    curl -s -k -H "Authorization: Basic $(echo -n catalin:AIQXN-GWTZZ-FCTDM-XAFQU | base64)" -H "Accept: application/json" -H "Content-Type:application/json" -d '{"date": "'"$date_time"'","deviceId":"0002-0655-0000-0000-0000-0001","data" : [{"dataTypeId": 2,"value": '$temperature'}]}' https://192.168.1.25/index.php/apps/sensorlogger/api/v1/createlog/ > /dev/null

    sleep 5
done