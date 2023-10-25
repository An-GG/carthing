void setup() {
  // put your setup code here, to run once:
  Serial1.begin(9600);
  Serial.begin(9600);

  Serial.println();
  Serial.println("> Mega 2560");
  Serial.println();
}

void loop() {
  // put your main code here, to run repeatedly:
  while (Serial1.available()) {
    Serial.println("readString: " > Serial1.readString());
  }
  delay(100);
  Serial.println();
  Serial.println("---");
}
