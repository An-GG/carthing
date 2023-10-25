#include <Arduino.h>
#include <BLEDevice.h>
#include <BLEService.h>
#include <BLECharacteristic.h>
#include "SecretConstants.h"


BLEAdvertising *pAdvertising;

BLECharacteristic *pCharacteristic_CommandInput;
BLECharacteristic *pCharacteristic_PredictedLockState;




void lock() {
  pCharacteristic_PredictedLockState->setValue("locked");
}


void unlock() {
  pCharacteristic_PredictedLockState->setValue("unlocked");
}







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

class CommandInputCallbacks: public BLECharacteristicCallbacks {

  void onRead(BLECharacteristic* pCharacteristic) {
    std::string val = pCharacteristic->getValue();
    Serial.print("  > CommandInput Read: ");
    Serial.println(val.c_str());
  }

  void onWrite(BLECharacteristic* pCharacteristic) {
    std::string val = pCharacteristic->getValue();
    Serial.print("  > CommandInput Write: ");
    Serial.println(val.c_str());

    if (val.c_str() == "lock") { lock(); }
    if (val.c_str() == "unlock") { unlock(); }
  }

};


class PredictedLockStateCallbacks: public BLECharacteristicCallbacks {

  void onRead(BLECharacteristic* pCharacteristic) {
    std::string val = pCharacteristic->getValue();
    Serial.print("  > PredictedLockState Read: ");
    Serial.println(val.c_str());
  }

  void onWrite(BLECharacteristic* pCharacteristic) {
    std::string val = pCharacteristic->getValue();
    Serial.print("  > PredictedLockState Write: ");
    Serial.println(val.c_str());
  }

};


void setup() {

  Serial.begin(115200);
  Serial.println();
  Serial.print("Service UUID: ");
  Serial.println(SERVICE_UUID);

  BLEDevice::init("ESP32");

  BLEServer *pServer = BLEDevice::createServer();
  BLEService *pMainService = pServer->createService(SERVICE_UUID);

  pCharacteristic_CommandInput = pMainService->createCharacteristic(COMMAND_INPUT_CHARACTERISTIC_UUID,  BLECharacteristic::PROPERTY_WRITE );
  pCharacteristic_PredictedLockState = pMainService->createCharacteristic(PREDICTED_LOCK_STATE_CHARACTERISTIC_UUID,  BLECharacteristic::PROPERTY_READ );

  pCharacteristic_PredictedLockState->setValue("unknown");

  pMainService->start();
  
  pAdvertising = pServer->getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  //BLEAdvertisementData advertisingData;
  //pAdvertising->setAdvertisementData(advertisingData);
  //pAdvertising->setAppearance(128); // Generic Tag
  pAdvertising->start();

  pServer->setCallbacks(new ConnectionCallbacks());
  pCharacteristic_CommandInput->setCallbacks(new CommandInputCallbacks());
  pCharacteristic_PredictedLockState->setCallbacks(new PredictedLockStateCallbacks());


  

  //BLEAdvertisementData advertisement_data;
  //advertisement_data.setCompleteServices(BLEUUID("0e2bd58b-72c5-47ea-ab2a-04ce94908a6d"))

  //pAdvertising->setAdvertisementData()
  //                                            https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // https://web.archive.org/web/20170502011826/https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.gap.appearance.xml



}

void loop() {

}
