# part A notes

what we really want is a similar experience to the tesla phone key but without using a custom app that has to run in the background on iOS
    - to do this with nonzero "security" we can use bluetooth pairing, so if paired device is within certain rssi 
    - need esp32 to show up in iOS's Bluetooh Settings, need to pretend to be a bluetooth audio device or something
        - Audio/Video Remote Control Profile (AVRCP) might be ideal if it works

```
https://github.com/pschatzmann/ESP32-A2DP?tab=readme-ov-file

prototyping/espstuff/a2dp_sink/a2dp_sink.ino
```
```
https://www.visualmicro.com/page/Easy-DIY-Bluetooth-Speaker-Project.aspx
```

# the project is now very rapidly approaching scuffed and unmaintable code territory 

--- 

alternative:
abandon pairing, literally just use advertised device name and check rssi

> is this even reliable? even assuming no low power mode nonsense, is this always available?


---

# part B notes: required bt app fallback

custom ios app 
 - two buttons: lock, unlock
 - easy: connect to esp using uuid, write password + action to esp32 
 - better: 
        - use time based rolling code as the password 
        - do this with bt pairing ? how secure even is this if i dont try

```
https://github.com/espressif/arduino-esp32/blob/master/libraries/BluetoothSerial/src/BluetoothSerial.h
```



---

LFG

<img width="511" alt="airpods_ultra" src="https://raw.githubusercontent.com/An-GG/carthing/master/prototyping/espstuff/a2dp_sink/airpods_ultra.png">

still not sure how to achieve this without advertising as an audio device, hid controller/keyboard/mouse, or **heart rate monitor**

