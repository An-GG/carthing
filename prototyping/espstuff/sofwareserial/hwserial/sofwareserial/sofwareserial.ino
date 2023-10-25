
void setup() {
  Serial.begin(9600); // Standard hardware serial port

  Serial1.begin(9600);

}

void loop() {
  Serial1.println("abc");
  Serial.println("abc");
  delay(500);
}
