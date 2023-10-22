#!/usr/bin/env bash 

arduino-cli compile -b esp32:esp32:esp32 ./a2dp_sink.ino

PORT="$(ls /dev/cu.usb*)"
arduino-cli upload -b esp32:esp32:esp32 -p $PORT ./a2dp_sink.ino

arduino-cli monitor -p $PORT --config baudrate=9600
