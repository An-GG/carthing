

void setup() {
  Serial.begin(9600);
  //Serial1.begin(9600, SERIAL_8N1, RXD2, TXD2);
  Serial2.begin(9600, SERIAL_8N1, 16, 17);
  Serial.println("Serial TX: GPIO 17 & RX GPIO 16");
}

void loop() {
    delay(5000);
    Serial2.println("henlo");
    Serial.println("henlo");
    delay(2000);
    Serial2.write("henlo\n");
    Serial.write("henlo\n");
}
