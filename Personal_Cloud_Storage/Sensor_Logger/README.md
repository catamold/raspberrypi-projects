---
title: Sensor Logger
parent: Personal Cloud Storage
has_children: false
---

## Sensor Logger

### Device configuration
**1.** To make data monitoring available on user's owncloud server, on Security page of the owncloud create an App password / token. For isntace the username: `talina` and pasword/token: `DKYYH-KKHUR-HZDXM-JFASK`

**2.** To register the device, for instance the core temperature of the Raspberry Pi, we will create the following POST request, by writing a random id to **deviceId** and some stuff to **deviceName**, **deviceType**, **deviceGroup**, **deviceParentGroup** and **deviceDataTypes**:

`curl -k -v -H "Authorization: Basic $(echo -n talina:DKYYH-KKHUR-HZDXM-JFASK | base64)" -H "Accept: application/json" -H "Content-Type:application/json" -d '{"deviceId":"0002-0655-0000-0000-0000-0001","deviceName":"Pi_Temperature","deviceType":"Raspberry_Pi_3B","deviceGroup":"Raspberry","deviceParentGroup":"Server 0","deviceDataTypes":[{"type":"cpu-core-temp","description":"CoreTemp","unit":"°C"}]}' https://192.168.1.25/index.php/apps/sensorlogger/api/v1/registerdevice/`

**3.** Now, you can log in your ownCloud account, then add the _deviceName_ widget chart on SensorLoger page.

**4.** We get the device *dataType* information using the following POST request, by passing the **deviceId** we created before:

`curl -k -v -H "Authorization: Basic $(echo -n talina:DKYYH-KKHUR-HZDXM-JFASK | base64)" -H "Accept: application/json" -H "Content-Type:application/json" -d '{"deviceId":"0002-0655-0000-0000-0000-0001"}' https://192.168.1.25/index.php/apps/sensorlogger/api/v1/getdevicedatatypes/`

**5.** A successful message will appear on Terminal and you have to remember the **id** received:
```
{"success":true,"message":"DataTypes for Device #0002-0655-0000-0000-0000-0001","data":[{"id":"2","description":"CoreTemp","type":"cpu-core-temp","short":"\u00b0C"}]}
```

**6.** We test the device data transmision using the following POST request, by passing the **dataTypeId** obtained on the latest response, a random date (if necessary) and temperature number:

`curl -k -v -H "Authorization: Basic $(echo -n talina:DKYYH-KKHUR-HZDXM-JFASK | base64)" -H "Accept: application/json" -H "Content-Type:application/json" -d '{"date":"2020-09-30 12:30:47","deviceId":"0002-0655-0000-0000-0000-0001","data" : [{"dataTypeId": 2,"value": 58.2}]}' https://192.168.1.25/index.php/apps/sensorlogger/api/v1/createlog/`

### Info and error codes
**Curl information**
- _-k_: Suppress certificate errors in curl
- _-v_: Use verbose output to get more information about the curl request
- _-X POST_: RESTful HTTP Post
- _-d_: JSON data
- _-H_: Show help text
- _-s ... > /dev/null_: Silent or quiet mode, it doesn't show progress meter or error messages, it makes Curl mute. It will still output the data you ask for, potentially even to the terminal/stdout unless you redirect it.

**Codes**
- _9001_ ... missing params
- _9002_ ... device already exists
- _9404_ ... not found
- _9405_ ... not allowed
- _9999_ ... unknown problem

### Automate POST data requests
To automate the data from device's temperature, we use [crontab](https://catamold.github.io/raspberrypi-projects/Minecraft_Server/Server_Save/README.html) to run the [temperatureLogger.sh bash file](https://github.com/catamold/raspberrypi-projects/releases/download/v3.0/temperatureLogger.sh) every 1 minute. The script file runs every 5 seconds for 12 times:

`* * * * * /home/pi/Scripts/temperatureLogger.sh`
