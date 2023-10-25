#!/usr/bin/env bash

PORT="$(ls /dev/cu.usb*)"
arduino-cli monitor -p $PORT --config baudrate=9600
