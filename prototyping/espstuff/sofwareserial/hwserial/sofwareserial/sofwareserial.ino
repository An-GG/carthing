

void setup() {
  Serial.begin(9600);
  //Serial1.begin(9600, SERIAL_8N1, RXD2, TXD2);
  Serial2.begin(9600, SERIAL_8N1, 16, 17);
  Serial.println("Serial TX: GPIO 17 & RX GPIO 16");
}

void loop() {
  while (Serial2.available()) {
    Serial.print(char(Serial2.read()));
  }
}
