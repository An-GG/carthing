#include <Arduino.h>
#include <SPI.h>

#define UNLOCK_BTN_RELAY_PIN 24
#define LOCK_BTN_RELAY_PIN 22

const int bufferSize = 100; // buffer size for incoming serial data
char inputBuffer[bufferSize];
const char* vars[] = {"predicted_lock_state"};
char predicted_lock_state[bufferSize] = "unknown"; // default state


void lock() {
      digitalWrite(LOCK_BTN_RELAY_PIN, HIGH);
      delay(250);
      digitalWrite(LOCK_BTN_RELAY_PIN, LOW);
}

void unlock() {
      digitalWrite(UNLOCK_BTN_RELAY_PIN, HIGH);
      delay(250);
      digitalWrite(UNLOCK_BTN_RELAY_PIN, LOW);
}


void displayHelp() {
  Serial.println("Available commands:");
  Serial.println("help - Displays this help message");
  Serial.println("unlock - Unlock command");
  Serial.println("lock - Lock command");
  Serial.println("bluetooth_scan - Start a Bluetooth scan");
  Serial.println("rfid_scan - Start an RFID scan");
  Serial.println("get [var] - Get value of a variable");
  Serial.println("set [var] [value] - Set value of a variable");
  Serial.println("list_vars - List all available variables");
}

void getVar(char* varName) {
  if (strcmp(varName, "predicted_lock_state") == 0) {
    Serial.println(predicted_lock_state);
  } else {
    Serial.println("Unknown variable.");
  }
}

void setVar(char* command) {
  char* varName = strtok(command, " ");
  char* value = strtok(NULL, "");

  if (varName != NULL && value != NULL) {
    if (strcmp(varName, "predicted_lock_state") == 0) {
      strncpy(predicted_lock_state, value, sizeof(predicted_lock_state) - 1);
      Serial.println("Value set.");
    } else {
      Serial.println("Unknown variable.");
    }
  } else {
    Serial.println("Invalid set command.");
  }
}

void listVars() {
  for (int i = 0; i < sizeof(vars) / sizeof(vars[0]); i++) {
    Serial.println(vars[i]);
  }
}


void setup() {
  Serial1.begin(9600);

  Serial.begin(9600);
  Serial.println("carthing serial interface. type 'help' to get a list of available commands");
  Serial.print("> ");
  pinMode(UNLOCK_BTN_RELAY_PIN, OUTPUT);
  pinMode(LOCK_BTN_RELAY_PIN, OUTPUT);
}

void loop() {
  if (Serial.available()) {
      int len = Serial.readBytesUntil('\n', inputBuffer, bufferSize);
      if (len > 0 && inputBuffer[len - 1] == '\r') {
          len--;  // decrement the length to ignore the '\r' character
      }
      inputBuffer[len] = '\0'; // Null-terminate the string

    // Check and handle command
    if (strcmp(inputBuffer, "help") == 0) {
      displayHelp();
    } else if (strcmp(inputBuffer, "unlock") == 0) {
      Serial.println("Unlock command received");
      unlock();
    } else if (strcmp(inputBuffer, "lock") == 0) {
      Serial.println("Lock command received");
      lock();
    } else if (strcmp(inputBuffer, "bluetooth_scan") == 0) {
      // Add your 'bluetooth_scan' functionality here
      Serial.println("Bluetooth scan started");
    } else if (strcmp(inputBuffer, "rfid_scan") == 0) {
      // Add your 'rfid_scan' functionality here
      Serial.println("RFID scan started");
    } else if (strncmp(inputBuffer, "get ", 4) == 0) {
      getVar(inputBuffer + 4);
    } else if (strncmp(inputBuffer, "set ", 4) == 0) {
      setVar(inputBuffer + 4);
    } else if (strcmp(inputBuffer, "list_vars") == 0) {
      listVars();
    } else {
      Serial.println("Unknown command. Type 'help' for available commands.");
    }
    Serial.print("> ");
  }

  if (Serial1.available()) {
    char c = Serial1.read();
    Serial.println();
    Serial.print("'");
    Serial.print(c);
    Serial.println(+ "' recieved on Serial1.");
    Serial.print("> ");
    if (c == 'L') { lock(); } 
    if (c == 'U') { unlock(); }
  }
}

