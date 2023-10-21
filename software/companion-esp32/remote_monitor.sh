#!/usr/bin/env bash 

ssh -t pro 'cd ~/Documents/Projects/carthing/software/companion-esp32 && PORT="$(ls /dev/cu.usb*)" && echo "PORT=$PORT - Git Diff:" && git diff && /usr/local/bin/arduino-cli monitor -p $PORT --config baudrate=115200'
