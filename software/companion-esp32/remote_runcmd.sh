#!/usr/bin/env bash 

#git aac 'remote compile & flash'

#git push

scp ./src/main.cpp pro:Documents/Projects/carthing/software/companion-esp32/src/main.cpp

ssh -t pro 'cd ~/Documents/Projects/carthing/software/companion-esp32 && /usr/local/bin/git pull && /usr/local/bin/pio run -t upload && PORT="$(ls /dev/cu.usb*)" && echo "PORT=$PORT - Git Diff:" && git diff && /usr/local/bin/arduino-cli monitor -p $PORT --config baudrate=115200'
