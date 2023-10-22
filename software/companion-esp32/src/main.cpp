#include <Arduino.h>

#include "BluetoothA2DPSink.h"

BluetoothA2DPSink a2dp_sink;


bool address_validator(esp_bd_addr_t remote_bda) {
  for (int i = 0; i < 5; i++) {
    Serial.print(remote_bda[i], HEX);
    Serial.print("-");
  }
  Serial.println(remote_bda[5], HEX);

  return true;
}






void setup() {
  Serial.begin(115200);

  a2dp_sink.set_address_validator(address_validator);
  a2dp_sink.start("AirPods Ultra", true);
}

void loop() {
  delay(200);
}