#!/usr/bin/env bash 

arduino-cli compile -b esp32:esp32:esp32 ./sofwareserial.ino

PORT="$(ls /dev/cu.usbserial*)"
arduino-cli upload -b esp32:esp32:esp32 -p $PORT ./sofwareserial.ino

arduino-cli monitor -p $PORT --config baudrate=9600
