git pull

pio run -t upload 

echo "Printing git diff:"

git diff

arduino-cli monitor -p /dev/cu.usbmodem14301 --echo
