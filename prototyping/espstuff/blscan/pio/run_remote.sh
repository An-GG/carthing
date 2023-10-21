#!/usr/bin/env bash 

git aac 'remote compile & flash'

git push

ssh -t pro 'cd ~/Documents/Projects/carthing/prototyping/espstuff/blscan/pio && /usr/local/bin/git pull && /usr/local/bin/pio run -t upload && PORT="$(ls /dev/cu.usb*)" && /usr/local/bin/arduino-cli monitor -p $PORT'
