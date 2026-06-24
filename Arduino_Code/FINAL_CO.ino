#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <Servo.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

// --------------------
// Parking IR sensors
// --------------------
int irPins[4] = {2, 3, 4, 5};

// Parking LEDs
int ledPins[4] = {A0, A1, A2, A3};

// --------------------
// Entrance Gate
// --------------------
int entranceIR = 7;
Servo entranceGate;
int entranceGatePin = 6;

// --------------------
// Exit Gate
// --------------------
int exitIR = 9;
Servo exitGate;
int exitGatePin = 8;

// --------------------
// Buzzer
// --------------------
int buzzerPin = 10;

// --------------------
// Servo angles
// --------------------
int closedAngle = 0;
int openAngle = 70;

// --------------------
// Gate timing variables
// --------------------
unsigned long entranceClearTime = 0;
unsigned long exitClearTime = 0;
bool entranceOpen = false;
bool exitOpen = false;

void setup() {
  lcd.init();
  lcd.backlight();

 // Serial.begin(9600); // HC-05 default baud rate

  // Parking IR sensors
  for (int i = 0; i < 4; i++) {
    pinMode(irPins[i], INPUT);
    pinMode(ledPins[i], OUTPUT);
  }

  // Gate IR sensors
  pinMode(entranceIR, INPUT);
  pinMode(exitIR, INPUT);

  // Buzzer
  pinMode(buzzerPin, OUTPUT);

  // Servos
  entranceGate.attach(entranceGatePin);
  exitGate.attach(exitGatePin);

  entranceGate.write(closedAngle);
  exitGate.write(closedAngle);

  lcd.setCursor(0, 0);
  lcd.print("Parking System");
}

void loop() {
  int freeSpaces = 0;
  int slotState[4];

  // --------------------
  // PARKING SLOT DETECTION
  // --------------------
  for (int i = 0; i < 4; i++) {
    int irValue = digitalRead(irPins[i]);

    if (irValue == HIGH) { // EMPTY
      digitalWrite(ledPins[i], HIGH);
      freeSpaces++;
      slotState[i] = 1;
    } else {               // FULL
      digitalWrite(ledPins[i], LOW);
      slotState[i] = 0;
    }
  }

  // --------------------
  // BUZZER LOGIC
  // --------------------
  
if (digitalRead(entranceIR) == LOW) {  // Car detected at entrance
  if (freeSpaces > 0) {
    // Open gate if there are free spaces
    entranceGate.write(openAngle);
    entranceOpen = true;
    entranceClearTime = 0;
    digitalWrite(buzzerPin, LOW);  // Turn buzzer off
  } else {
    // No free spaces: keep gate closed and sound buzzer
    entranceGate.write(closedAngle);
    entranceOpen = false;
    digitalWrite(buzzerPin, HIGH); // Turn buzzer on
  }
} else if (entranceOpen) {
  // Close gate after delay if car passed
  if (entranceClearTime == 0) {
    entranceClearTime = millis();
  }
  if (millis() - entranceClearTime >= 2000) {
    entranceGate.write(closedAngle);
    entranceOpen = false;
  }
  digitalWrite(buzzerPin, LOW);  // Turn buzzer off when gate is closing
} else {
  // If entrance is clear and gate is closed, buzzer off
  digitalWrite(buzzerPin, LOW);
}

  // --------------------
  // EXIT GATE LOGIC
  // --------------------
  if (digitalRead(exitIR) == LOW) {
    exitGate.write(openAngle);
    exitOpen = true;
    exitClearTime = 0;
  } else if (exitOpen) {
    if (exitClearTime == 0) {
      exitClearTime = millis();
    }
    if (millis() - exitClearTime >= 2000) {
      exitGate.write(closedAngle);
      exitOpen = false;
    }
  }

  // --------------------
  // LCD UPDATE
  // --------------------
  lcd.setCursor(0, 1);
  lcd.print("Free: ");
  lcd.print(freeSpaces);
  lcd.print("    ");

  // --------------------
  // BLUETOOTH DATA SEND
  // --------------------
  //Serial.println(
  //String("S1:") + slotState[0] + "," +
  //"S2:" + slotState[1] + "," +
  //"S3:" + slotState[2] + "," +
  //"S4:" + slotState[3]
);

  delay(200);
}
