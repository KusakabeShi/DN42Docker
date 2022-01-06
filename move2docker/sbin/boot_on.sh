#!/bin/bash
while :
do
  curl --connect-timeout 10 --silent --output /dev/null $REBOOT_BOOTON_URL
done
