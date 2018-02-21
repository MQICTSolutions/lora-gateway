#!/bin/bash

# function gets called to do any cleanup before rebooting
restart_network()
{
   # add an entry in syslog to keep track of down times
   logger -p0 "[RESTART NETWORKING]Internet connection is unreachable - restart networking"
   #/etc/init.d/networking restart   
   # stop & start USB 3G
   cd /home/pi/
   ./SetupUsb3gModem stop
   ./SetupUsb3gModem start
}


# function gets called to do any cleanup before rebooting
reboot_host()
{
   # add an entry in syslog to keep track of down times
   logger -p0 "[REBOOT NOTICE]Internet connection is unreachable - going down for reboot"
   echo 1 > /home/pi/rebootstate
   reboot
}

# host we should always be able to reach when wi-fi is up
PING_ADDR="8.8.8.8"

# number of seconds to wait before checking ping again
SLEEP_SECS=300

# number of times ping is allowed to fail before a reboot
MAX_TIMES_DOWN=5
MAX_TIMES_TRY=3

# number of consecutive times, in loop, that PING_ADDR has been unreachable
down_count=0

# loop forever
while [ 1 ]; do
   rm -f /home/pi/rebootstate
   # check using two  arp packets - if ping returns non-zero status, assume it's an error
   ping -c 4 ${PING_ADDR}
   result=$?

   # if ping result is non-zero, add to the down counter
   #   if result is zero (successful) reset down_count (temp network hiccup?)
   test ${result} -ne 0 && let down_count="$down_count+1"
   test ${result} -eq 0 && down_count=0

   # if ping fails in the loop MAX_TIMES_DOWN (consecutively) then reboot
   test $down_count -gt ${MAX_TIMES_DOWN} && reboot_host
   test $down_count -eq ${MAX_TIMES_TRY} && restart_network

   # wait a while before checking again
   sleep ${SLEEP_SECS};

done
