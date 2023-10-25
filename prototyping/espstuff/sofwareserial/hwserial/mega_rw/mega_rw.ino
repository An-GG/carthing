void setup() {
  // put your setup code here, to run once:
  Serial1.begin(38400);
  Serial.begin(9600);
  Serial.println("> Mega 2560");
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(500);
  Serial1.write("ABC");
  delay(500);
  String s = Serial.readString();
  Serial.println("ESP32: '" + s + "'");
}
