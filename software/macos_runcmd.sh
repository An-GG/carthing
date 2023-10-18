git pull

pio run -t upload 

echo "Printing git diff:"

git diff

platformio device monitor -p /dev/cu.usbmodem14301 --echo
