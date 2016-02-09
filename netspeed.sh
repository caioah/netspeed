#!/bin/bash
# netspeed.sh

echo "Starting test @ $(date)"
trap "{ echo Stopping...; exit 255; }" EXIT
loop=0
min=60
percent=40
count=20
id=`speedtest --list | sed -n 3p | cut -d')' -f1`
host=`curl -s http://www.speedtest.net/speedtest-servers.php | xmllint --xpath "string(//settings/servers/server[@id="$id"]/@host)" - | cut -d':' -f1`

cmd="speedtest --simple --server $id"
while [[ $# > 0 ]]; do
   case $1 in
   -s|--secure)
      cmd="$cmd --secure"
      echo "Secure connection"
   ;;
   -m|--minutes)
      min=$2
      shift 
   ;;
   -ds|--down-speed)
      dspeed=$2
      shift 
   ;;
   -c|--count)
      count=$2
      echo "Ping count: $count"
      shift 
   ;;
   -l|--loop)
      loop=1
      echo "Loop every ${min}m"
   ;;
   *)
      echo "Unknown option: $1"
      exit 1
   ;;
   esac
   shift
done

while :
do
   echo "host: $id - $host"
   echo "date: $(date)"
   ping=`ping -c $count $host`
   if [[ `echo $ping | grep unknown\ host` ]]; then
      echo "Link is down !!!"
   else
      loss=`echo "$ping" | grep packet\ loss | cut -d' ' -f6` 
      avg=`echo "$ping" | grep rtt | cut -d'/' -f5`
      mdev=`echo "$ping" | grep rtt | cut -d'/' -f7`
      echo "loss: $loss"
      echo "avg: $avg ms"
      echo "jitter: $mdev"

      output=`$cmd`
      echo "$output"
      if [[ $dspeed ]]; then
         dl=`echo "$output" | grep Download`
	 spd=`echo "$dl" | cut -d' ' -f2`
	 pc=`bc -l <<< "($spd * 100)/$dspeed"`
	 if [ `bc <<< "$pc<$percent"` -eq 1 ]; then
	    echo "Speed lower than ${percent}% !!!"
	 else
            echo "Within expected speed"
	 fi
      fi
   fi
   if [ $loop -eq 1 ]; then
      echo "sleeping..."
      sleep "${min}m"
   else
      exit 0
   fi
done
