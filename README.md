# netspeed
A bash script to test broadband speed and jitter that uses speedtest.net and ping

Description
-----------
This is a simple bash script that combines speedtest and ping to produce more extensive results, as required by certain providers in order to determine connection problems.

# Uses
* speedtest
* iputils/ping
* xmllint
* curl

# Usage
syntax: netspeed.sh [-c | --count \<count\>] [-s | --secure] [-m | --minutes \<minutes\>] [-ds | --down-speed \<mbits\>]
[-l | --loop]

* [-c | --count \<count\>] : Max icmp count when pinging. Higher values will make the script even slower. (default: 10)
* [-s | --secure] : HTTPS connection to speedtest server (speedtest option) (default: no)
* [-m | --minutes \<minutes\>] : Time in minutes to sleep before looping. This is only enabled when combined with --loop. (default: 60)
* [-ds | --down-speed \<mbits\>] : Downstream speed in Mbits/s to compare. This only affects percentage speed calculation at the end of each loop. Default percentage is 40% (as established by Anatel in Brazil, 2014). (default: disabled)
* [-l | --loop] : Enable looping at every specified amount of minutes. (default: disabled)

Examples
--------
```
$ ./netspeed.sh #run once with default settings and output to stdout
$ ./netspeed.sh -c 20 -ds 60 --secure #run once, ping count 20, secure connection, down-speed 60 mbits/s, output to stdout
$ ./netspeed.sh --minutes 30 -ds 30 --loop > ~/netspeed.log #30 minutes loop, down-speed 30 mbits/s, output to ~/netspeed.log
$ nohup ./netspeed.sh -ds 120 --loop 0<&- &> ~/netspeed.log & #run as daemon with output to ~/netspeed.log, down-speed 120 mbits/s
```

Output
------
```
Starting test @ <start-date>
{<settings-output>}
host: <id> - <target>
date: <date>
loss: <loss>
avg: <avg> ms
jitter: <mdev> ms
Ping: <latency> ms
Download: <down-speed> Mbit/s
Upload: <up-speed> Mbit/s
(...)
Stopping...
```

* <start-date> : 'date' command output when starting the script
* <settings-output> : any changes to default settings will be displayed here
* <id> : Host ID according to speedtest.net
* <target> : Host name according to speedtest.net
* <date>: timestamp of the current speedtest
* <loss> : percentage of packets lost on ping
* <avg> : Average ms of RTT
* <mdev> : Connection jitter, also known as mdev on ping
* <down-speed> : Downstream speed in Mbits/s
* <up-speed> : Upstream speed in Mbits/s
