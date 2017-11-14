#! /bin/sh

set -u

export WEBSOCKETEMAIL_TOKEN=$(cat websocketemail_token.txt)

# A secret id that people can't guess
gateid=gate12345

# initialize gpio
echo 13 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio13/direction

while true
do
  if wsemail -timeout 0 -for-address $gateid@websocket.email \
     | grep -q "open sesame"
  then
    # Trigger the gate if the email contained the secret incantation
    echo 1 > /sys/class/gpio/gpio13/value 
    sleep 0.1
    echo 0 > /sys/class/gpio/gpio13/value 
  fi
  # don't loop too fast if there is an error somewhere.
  sleep 1
done
