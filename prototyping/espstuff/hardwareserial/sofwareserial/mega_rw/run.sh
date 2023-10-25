#!/usr/bin/env bash 

arduino-cli compile -b arduino:avr:mega ./mega_rw.ino

PORT="$(ls /dev/cu.usbmodem*)"
arduino-cli upload -b arduino:avr:mega -p $PORT ./mega_rw.ino

arduino-cli monitor -p $PORT --config baudrate=115200
