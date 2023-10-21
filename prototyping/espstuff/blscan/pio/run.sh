#!/usr/bin/env bash 

/usr/local/bin/pio run -t upload -t compiledb 

PORT="$(ls /dev/cu.usb*)" 
/usr/local/bin/arduino-cli monitor -p $PORT
