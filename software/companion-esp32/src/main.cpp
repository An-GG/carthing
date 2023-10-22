#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLEScan.h>
#include <BLE2902.h>
#include "BluetoothA2DPSink.h"
#include "esp_log.h"

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
uint8_t value = 0;

BluetoothA2DPSink a2dp_sink;

int scanTime = 5; //In seconds
BLEScan* pBLEScan;


class MyAdvertisedDeviceCallbacks: public BLEAdvertisedDeviceCallbacks {
    void onResult(BLEAdvertisedDevice advertisedDevice) {
        Serial.println();
      Serial.printf(">> %s Advertised Device: %s \n", advertisedDevice.getName().c_str(), advertisedDevice.toString().c_str());
    }
};
// UUIDs for service and characteristic
#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"  // Randomly generated, but you can change this
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"  // Randomly generated

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        Serial.print(" !> onConnect - nConnected:");
      Serial.println(pServer->getConnectedCount());
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {

        Serial.print(" !> onDisconnect - nConnected:");
      Serial.println(pServer->getConnectedCount());
      deviceConnected = false;
    }
};

void setup() {

  esp_log_level_set("*", ESP_LOG_NONE);

  Serial.begin(115200);

  // Create the BLE Device
  BLEDevice::init("ESP32_BLE");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                     CHARACTERISTIC_UUID,
                     BLECharacteristic::PROPERTY_READ   |
                     BLECharacteristic::PROPERTY_WRITE  |
                     BLECharacteristic::PROPERTY_NOTIFY |
                     BLECharacteristic::PROPERTY_INDICATE
                   );

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->start();

  a2dp_sink.start("A2DP_Music_Sink", true); 


    
  pBLEScan = BLEDevice::getScan(); //create new scan
  pBLEScan->setAdvertisedDeviceCallbacks(new MyAdvertisedDeviceCallbacks());
  pBLEScan->setActiveScan(true); //active scan uses more power, but get results faster
  pBLEScan->setInterval(100);
  pBLEScan->setWindow(99);  // less or equal setInterval value
}

void loop() {
  // Notify based on some condition or logic (this is just an example)
  if (deviceConnected) {
    //pCharacteristic->setValue(&value, 1);
    //pCharacteristic->notify();
    value++;
    delay(1000); // Just for example purposes
  }
  // disconnecting
  if (!deviceConnected && oldDeviceConnected) {
    delay(500);  // Give a short time to notify
    pServer->startAdvertising();  // Restart advertising
    oldDeviceConnected = deviceConnected;
  }
  if (deviceConnected && !oldDeviceConnected) {
    oldDeviceConnected = deviceConnected;
  }


  BLEScanResults foundDevices = pBLEScan->start(scanTime, true);
  Serial.print(">> Devices found: ");
  Serial.print(foundDevices.getCount());
  Serial.println(" -  Scan done!");
  //pBLEScan->clearResults();   // delete results fromBLEScan buffer to release memory
  delay(5000);
}
