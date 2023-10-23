#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEService.h>
#include "SecretConstants.h"


BLEAdvertising *pAdvertising;

class ConnectionCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer *pServer) {
    Serial.println("--> Device Connected.");
  }
  void onDisconnect(BLEServer *pServer) {
    Serial.println("--> Device Disconnected.");
    delay(500);
    pServer->startAdvertising();
  }
};


void setup() {

  BLEDevice::init("ESP32");

  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pServiceA = pServer->createService("0e2bd58b-72c5-47ea-ab2a-04ce94908a6d");
  BLEService *pServiceB = pServer->createService(SERVICE_UUID);

  uint32_t ble_characteristic_prop_flags = BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_WRITE;
  Serial.print("ble_characteristic_prop_flags: "); Serial.println(ble_characteristic_prop_flags, HEX);
  BLECharacteristic *pCharacteristicA = pServiceA->createCharacteristic("409a87f8-726d-49dc-8c1b-187e5fbedc4b",  ble_characteristic_prop_flags );
  BLECharacteristic *pCharacteristicB = pServiceB->createCharacteristic("fd961c22-592b-4fbb-8c7d-fac314e95608", ble_characteristic_prop_flags);
  pCharacteristicA->setValue("A");
  pCharacteristicB->setValue("B");

  pServiceA->start();
  pServiceB->start();
  
  pAdvertising = pServer->getAdvertising();
  //pAdvertising->setAppearance(128); // Generic Tag
  pAdvertising->addServiceUUID(SERVICE_UUID);
  //pAdvertising->addServiceUUID("0e2bd58b-72c5-47ea-ab2a-04ce94908a6d");
  pAdvertising->start();

  pServer->setCallbacks(new ConnectionCallbacks());

  

  //BLEAdvertisementData advertisement_data;
  //advertisement_data.setCompleteServices(BLEUUID("0e2bd58b-72c5-47ea-ab2a-04ce94908a6d"))

  //pAdvertising->setAdvertisementData()
  //                                            https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // https://web.archive.org/web/20170502011826/https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.gap.appearance.xml



}

void loop() {

}
