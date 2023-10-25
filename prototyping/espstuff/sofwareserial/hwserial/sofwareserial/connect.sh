#!/usr/bin/env bash

PORT="$(ls /dev/cu.usbserial*)"
arduino-cli monitor -p $PORT --config baudrate=9600
