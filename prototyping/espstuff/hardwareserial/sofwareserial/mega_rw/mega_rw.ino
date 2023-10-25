void setup() {
  // put your setup code here, to run once:
  Serial1.begin(9600);
  Serial.begin(115200);

  Serial.println();
  Serial.println("> Mega 2560 reading from Serial1");
  Serial.println();
}

void loop() {
    if (Serial1.available()) {
        Serial.print("\n>>>");
        while(Serial1.available()) {
            char c = Serial1.read();
            Serial.write(c);
            Serial.write('|');
            Serial.print(int(c));
        }
        Serial.println("<<<");
    }
}
