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

### ~~the project is now very rapidly approaching scuffed and unmaintable code territory~~ 
its aight 


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

---

## so originally
we were avoiding implementing a HID device for security / privacy reasons but the reality is
<img width="667" alt="Screenshot 2023-10-26 at 12 09 13 PM" src="https://github.com/An-GG/carthing/assets/20458990/563e91ac-e2da-4845-b81d-5b055d44bea8">


**basically any of these could be HID input and it's not really clear anyway, so**

> edit: **holy shit it literally does actually look exactly the same lmao**

![btflip_desktop](https://github.com/An-GG/carthing/assets/20458990/c0d726b4-7905-44a9-8a1c-64bd8f5380b7)

![btflip](https://github.com/An-GG/carthing/assets/20458990/9e27e8e0-3e07-4b78-8fd2-51c2872283b6)

>>> **ok yeah** going for security or whatever was mega low IQ decision making, should've actually looked at implementation first. *after a device is paired it can just casually become a HID device* ***and still stay paired***



<img width="507" alt="IMG_5200" src="https://github.com/An-GG/carthing/assets/20458990/16368639-92b1-4aca-ab87-2f64992806c9">

it looks exactly the same to the user and ios will reconnect*. user controls initial pairing invocation after which connection is secure



<img width="794" alt="Screenshot 2023-10-26 at 3 19 11 PM" src="https://github.com/An-GG/carthing/assets/20458990/a8b55937-84d0-421f-ac4b-8474bc6c95dc">


#### bottom line: use whatever bt protocol its fine


# asterisk *
![IMG_5204](https://github.com/An-GG/carthing/assets/20458990/06b7efe7-0829-4496-ae21-9d1f26874ee6)


---



still not sure how to achieve this without advertising as an audio device, hid controller/keyboard/mouse, or ~~heart rate monitor~~ [https://support.apple.com/en-us/HT204387](https://support.apple.com/en-us/HT204387)


[https://www.silabs.com/documents/public/application-notes/AN986.pdf](https://www.silabs.com/documents/public/application-notes/AN986.pdf)

|esp32 supports |apple supports|
|---|---|
|HFP AG |- Hands-Free Profile (**HFP** 1.8)|
| |- Phone Book Access Profile (**PBAP** 1.2)|
|A2DP |- Advanced Audio Distribution Profile (**A2DP** 1.4)|
|* |    - *Audio/Video Remote Control Profile (**AVRCP** 1.6)|
| |- Personal Area Network (**PAN**) Profile|
|HID |- Human Interface Device (**HID**) Profile|
| |- Message Access Profile (**MAP** 1.4)|
| |- Braille - hhhhhMMMMHmmMMMMM 🤔|
| |- Wireless iPhone Accessory Protocol (**WiAP**) (assuming this is not worth exploring (i like making shit assumptions))|
|SPP (serial) | |
|L2CAP (lower level hw access?) | |
|SDP service discovery protocol (but A2DP doesnt use it, not universal) | |


from: 
```
https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/bluetooth/esp_l2cap_bt.html
```

<img width="371" alt="Screenshot 2023-10-26 at 11 42 55 AM" src="https://github.com/An-GG/carthing/assets/20458990/f5f32228-530a-44fa-8d04-25e58ee6e65f">



<img width="679" alt="Screenshot 2023-10-22 at 9 52 02 AM" src="https://github.com/An-GG/carthing/assets/20458990/35741b3d-606e-46f3-9f34-5fd0fca6f16c">

> **Addendum:**  note: the png above is quite trash for trying to figure out what the actual advertised service UUID is as seen by computers/phones. even though the "uuid" for a2dp_sink is **110b** (hex or literal characters?),  linux computer shows the full UUID: (0000**110b**-0000-1000-8000-00805f9b34fb)



![IMG_5207](https://github.com/An-GG/carthing/assets/20458990/ea5589c9-c7ac-443a-8103-cb30630e3b2a)


---


# so for iOS

using **SwiftUI**
- admittedly really great templating syntax + beautiful defaults. if this was html i would love html.
- implemented as
    - a swift playground (compile and deploy all on ipad)
    - xcode project
 
both are swiftui with prob identical code  


 -> xcode project 
---

**they moved the goddamn plist**

```
https://developer.apple.com/forums/thread/727969
```

<img width="1878" alt="Screenshot 2023-10-23 at 7 54 46 AM" src="https://github.com/An-GG/carthing/assets/20458990/07d9b431-0c32-4f33-9543-35cefa2d2f86">

<br>

## it's here now wtf

<img width="1254" alt="c" src="https://github.com/An-GG/carthing/assets/20458990/8ac3b663-14c3-4b01-8fc0-2b55e6c50346">

confirmed you don't need to add more than the **Privacy - Bluetooth always usage description** to the info.plist for scanning, connecting, reading/writing for the keyfob app


---

<img width="507" alt="Screenshot 2023-10-23 at 8 20 31 AM" src="https://github.com/An-GG/carthing/assets/20458990/0f383a90-d0ed-4351-89f0-b898f633e9ad">
<img width="717" alt="Screenshot 2023-10-23 at 8 14 18 AM" src="https://github.com/An-GG/carthing/assets/20458990/bf3ca2ce-3410-499c-891d-4382f1d33adc">



there's a __required__ *empty* Info.plist in the project folder, but it ___explicitly doesn't show up in the object tree___ in Xcode ????  

# 🤡 

thank god this was the first result on google

anywhen
--- 


 --> playgrounds project
---

setting up delegates for corebluetooth in swiftui from empty base class didn't work for some reason idk didn't look into it
 - required inheretence pattern was big stupid
  - ez pz with this

inhereting a UIViewController seems to work tho, **but you have to add it to the view lmao** 

# ¯\_(ツ)_/¯ 

this scuffed shit will do for now
```swift


let appvc = ScannerViewController()


class ScannerViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!


.
.
.


class MainVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(appvc.view)
        appvc.view.frame = view.frame
    }
    override func viewDidLayoutSubviews() {
        appvc.view.frame = view.frame
    }
}

struct MyUIViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainVC {
        return MainVC()
    }
    func updateUIViewController(_ uiViewController: MainVC, context: Context) {
    }
}

```





https://github.com/An-GG/carthing/assets/20458990/ce36b7af-db1b-407d-98c6-88dba1b8c95b


that's it. that's the entire app.

# - [✅] part B done

---

# part A objective
## use rssi + tricks to achieve tesla passive carkey  ==without background app refresh==


> Espressif ( Nvidia if iot devkits were GPUs ) provides full stack first party IDE which is really nice espc since there are already lots of variants of nodemcu boards
```
https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/linux-macos-setup.html#get-started-prerequisites
```

<img width="1436" alt="peak computer" src="https://github.com/An-GG/carthing/assets/20458990/4319681b-4a2f-4859-b459-42aac67c4964">

- no clue if [this thing](https://a.co/d/fkkYqNX) has a gpio led or not blink sketch doesnt work

for new project
- get_idf
- idf.py set-target esp32
- **idf.py menuconfig** - seems like it just adjusts any C++ #defs 
- idf.py -p /dev/cu.usbserial-0001 flash monitor
<br><br>

<img width="788" alt="Screenshot 2023-10-26 at 1 37 54 PM" src="https://github.com/An-GG/carthing/assets/20458990/02309bf2-cca5-423a-a3c6-690bbbf4d2f5">

bro???

