#!/usr/bin/env bash 

arduino-cli compile -b esp32:esp32:esp32 blscan.ino

PORT="$(ls /dev/cu.usb*)"
arduino-cli upload -b esp32:esp32:esp32 -p $PORT blscan.ino

arduino-cli monitor -p $PORT --config baudrate=9600
