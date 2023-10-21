#!/usr/bin/env bash 

git aac 'remote compile & flash'

git push

ssh pro 'cd ~/Documents/Projects/carthing/prototyping/espstuff/blscan/pio && /usr/local/bin/git pull && ./run.sh'
