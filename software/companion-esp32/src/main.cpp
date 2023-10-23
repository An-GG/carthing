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
  BLEService *pMainService = pServer->createService(SERVICE_UUID);

  BLECharacteristic *pCharacteristic_CommandInput = pMainService->createCharacteristic(COMMAND_INPUT_CHARACTERISTIC_UUID,  BLECharacteristic::PROPERTY_WRITE );
  BLECharacteristic *pCharacteristic_PredictedLockState = pMainService->createCharacteristic(PREDICTED_LOCK_STATE_CHARACTERISTIC_UUID,  BLECharacteristic::PROPERTY_READ );

  pMainService->start();
  
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
