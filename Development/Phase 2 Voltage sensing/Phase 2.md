```c++

#include <LiquidCrystal_I2C.h>
#include <Wire.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

const int pinBoth = A0;  // divider tap for "voltage over both capacitors"
const int pinOne  = A1;  // divider tap for "voltage over one capacitor"
const int pinLoad = A3;  // divider tap for "output voltage over the load"

// Calibration factor = how much to multiply the pin's 0-5V reading by
// to reconstruct the real voltage at that divider's input.
float calBoth = 4.30; // (3.3k + 1k) / 1k
float calOne  = 4.30; // (3.3k + 1k) / 1k
float calLoad = 1.10; // (100 + 1k) / 1k

const char* surname = "Mtembu"; // first 8 characters of surname

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();
}

float readVoltage(int pin, float calFactor) {
  int raw = analogRead(pin);
  float pinVoltage = (raw / 1023.0) * 5.0;
  return pinVoltage * calFactor;
}

void loop() {
  float vBoth = readVoltage(pinBoth, calBoth);
  float vOne  = readVoltage(pinOne, calOne);
  float vLoad = readVoltage(pinLoad, calLoad);

  Serial.print("A0 (both): ");
  Serial.print(vBoth, 2);
  
  Serial.print("V   A1 (one): ");
  Serial.print(vOne, 2);
  
  Serial.print("V   A3 (load): ");
  Serial.print(vLoad, 2);
  Serial.println("V");

  // ---- Row 0: mode placeholder + output voltage ..... surname ----
  lcd.setCursor(0, 0);
  lcd.print("--");       // series/parallel symbol goes here once the relay
                          // and custom characters are added in a later phase
  lcd.print(vLoad, 2);
  lcd.print("V");

  int surnameLen = strlen(surname);
  lcd.setCursor(16 - surnameLen, 0);
  lcd.print(surname);

  // ---- Row 1: voltage over both capacitors voltage over one ----
  lcd.setCursor(0, 1);
  lcd.print(vBoth, 2);
  lcd.print("V");

  char oneStr[7];
  dtostrf(vOne, 5, 2, oneStr); // right-justified to a width of 5
  lcd.setCursor(16 - (strlen(oneStr) + 1), 1);
  lcd.print(oneStr);
  lcd.print("V");

  delay(500);
}
```