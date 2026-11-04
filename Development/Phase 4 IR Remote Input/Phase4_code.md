```c++
#include <IRremote.hpp>
#include <LiquidCrystal_I2C.h>
#include <Wire.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

// Pins & Constants
const int relayPin = 12, IR_PIN = 3, pinBoth = A0, pinOne = A1;
const float calBoth = 4.30, calOne = 4.30;
const char* surname = "Mtembu";

// State Variables
const unsigned long dwellTime = 5000;
bool relayState = false;
unsigned long lastSwitch = 0, irUntil = 0;
int first = -1, second = -1;
bool showIR = false;

int decode(unsigned long c) {
  if (c == 4077698816UL) return 0;
  if (c == 4010852096UL) return 1;
  if (c == 3994140416UL) return 2;
  if (c == 3977428736UL) return 3;
  if (c == 3944005376UL) return 4;
  if (c == 3927293696UL) return 5;
  if (c == 3910582016UL) return 6;
  if (c == 3877158656UL) return 7;
  if (c == 3860446976UL) return 8;
  if (c == 3843735296UL) return 9;
  return -1;
}

float readV(int pin, float cal) { return (analogRead(pin) / 1023.0) * 5.0 * cal; }

void setup() {
  Serial.begin(9600);
  lcd.init(); lcd.backlight();
  pinMode(relayPin, OUTPUT); digitalWrite(relayPin, LOW);
  IrReceiver.begin(IR_PIN, ENABLE_LED_FEEDBACK);
  lastSwitch = millis();
}

void loop() {
  // --- IR Input Handling ---
  if (IrReceiver.decode()) {
    int d = decode(IrReceiver.decodedIRData.decodedRawData);
    if (d >= 0) {
      if (first == -1) { 
        first = d; 
        lcd.setCursor(0, 1); 
        lcd.print(F("Input = ")); lcd.print(first); lcd.print(F(".00V   ")); 
        showIR = true; 
      } else if (second == -1) { 
        second = d; 
        lcd.setCursor(0, 1); 
        lcd.print(F("Input = ")); lcd.print(first); lcd.print(F(".")); lcd.print(second); lcd.print(F("V     ")); 
        irUntil = millis() + 1000; // Lock for 1 second pause
        showIR = true;
      }
    }
    IrReceiver.resume();
  }

  // --- Clear IR Display after 1s Timeout ---
  if (showIR && second != -1 && millis() >= irUntil) {
    showIR = false;
    first = second = -1; // Reset digits for next capture
  }

  // --- Relay Toggle ---
  if (millis() - lastSwitch >= dwellTime) {
    relayState = !relayState;
    digitalWrite(relayPin, relayState ? HIGH : LOW);
    lastSwitch = millis();
  }

  // --- Voltage Sensing ---
  float both = readV(pinBoth, calBoth);
  float one = readV(pinOne, calOne);

  // --- LCD Updates ---
  // Row 0: Mode + Surname
  lcd.setCursor(0, 0);
  lcd.print(relayState ? F("PA") : F("SE"));
  lcd.print(F("--.--V"));
  lcd.setCursor(16 - strlen(surname), 0);
  lcd.print(surname);

  // Row 1: Normal Voltages (only drawn when IR pause is inactive)
  if (!showIR) {
    lcd.setCursor(0, 1);
    lcd.print(both, 2); lcd.print(F("V   "));
    lcd.print(F("   ")); lcd.print(F("   "));
    char s[7]; dtostrf(one, 5, 2, s);
    lcd.setCursor(16 - strlen(s) - 1, 1);
    lcd.print(s); lcd.print(F("V"));
  }

  delay(100);
}
```