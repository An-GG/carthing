#!/usr/bin/env bash

PORT="$(ls /dev/cu.usbmodem*)"
arduino-cli monitor -p $PORT --config baudrate=115200
