#!/usr/bin/env bash 

git aac 'remote compile & flash'

git push

ssh pro 'cd ~/Documents/Projects/carthing/prototyping/espstuff/blscan/pio && /usr/local/bin/git pull && /usr/local/bin/pio run -t upload -t compiledb -t monitor'
