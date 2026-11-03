Standalone circuit: IR receiver on pin 3 only, decoding button presses, temporarily displaying the two digits entered on the LCD, then reverting after 1 second. No output regulation yet — just prove input capture and LCD text behavior.

````c++
#include <IRremote.hpp>
#include <LiquidCrystal_I2C.h>
#include <Wire.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

// ---- Pins ----
const int relayPin = 12;
const int IR_PIN = 3;
const int pinBoth = A0;  // C1(+) / Solar+  -> voltage over BOTH capacitors
const int pinOne  = A1;  // C2(+)           -> voltage over ONE capacitor
const int pinLoad = A3;  // not wired yet - regulation stage comes in Phase 5

// ---- Calibration ----
float calBoth = 4.30; // (3.3k + 1k) / 1k
float calOne  = 4.30; // (3.3k + 1k) / 1k
float calLoad = 1.10; // (100 + 1k) / 1k - unused for now

const char* surname = "Mtembu";

// ---- Relay timing (non-blocking) ----
const unsigned long dwellTime = 5000;
bool relayEnergized = false;
unsigned long lastSwitch = 0;

// ---- IR digit capture state ----
int firstDigit = -1;
int secondDigit = -1;
bool showingIRResult = false;
unsigned long irDisplayUntil = 0;

int decodeDigit(unsigned long code) {
  switch (code) {
    case 4077698816: return 0;
    case 4010852096: return 1;
    case 3994140416: return 2;
    case 3977428736: return 3;
    case 3944005376: return 4;
    case 3927293696: return 5;
    case 3910582016: return 6;
    case 3877158656: return 7;
    case 386044697:  return 8; // double-check this code, looked truncated earlier
    case 3843735296: return 9;
    default: return -1;
  }
}

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();

  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW); // start de-energized = SERIES

  IrReceiver.begin(IR_PIN, ENABLE_LED_FEEDBACK);

  lastSwitch = millis();
  Serial.println("Phase 4: relay + voltage sensing + LCD + IR");
}

float readVoltage(int pin, float calFactor) {
  int raw = analogRead(pin);
  float pinVoltage = (raw / 1023.0) * 5.0;
  return pinVoltage * calFactor;
}

void handleIR() {
  if (IrReceiver.decode()) {
    unsigned long code = IrReceiver.decodedIRData.decodedRawData;
    int digit = decodeDigit(code);

    if (digit >= 0) {
      if (firstDigit == -1) {
        firstDigit = digit;
        lcd.setCursor(0, 1);
        lcd.print("Input = ");
        lcd.print(firstDigit);
        lcd.print(".00V   ");
        showingIRResult = true; // holds the row override while waiting too
      } else {
        secondDigit = digit;
        lcd.setCursor(0, 1);
        lcd.print("Input = ");
        lcd.print(firstDigit);
        lcd.print(".");
        lcd.print(secondDigit);
        lcd.print("V     ");
        irDisplayUntil = millis() + 1000;
        showingIRResult = true;
      }
    }
    IrReceiver.resume();
  }
}

void loop() {
  handleIR();

  // Non-blocking relay toggle
  if (millis() - lastSwitch >= dwellTime) {
    relayEnergized = !relayEnergized;
    digitalWrite(relayPin, relayEnergized ? HIGH : LOW);
    lastSwitch = millis();
  }

  float vBoth = readVoltage(pinBoth, calBoth);
  float vOne  = readVoltage(pinOne, calOne);

  Serial.print(relayEnergized ? "PARALLEL " : "SERIES   ");
  Serial.print("A0(both): "); Serial.print(vBoth, 2);
  Serial.print("V   A1(one): "); Serial.print(vOne, 2);
  Serial.println("V");

  // ---- Row 0: mode + load placeholder ..... surname (always shown) ----
  lcd.setCursor(0, 0);
  lcd.print(relayEnergized ? "PA" : "SE");
  lcd.print("--.--V");
  int len = strlen(surname);
  lcd.setCursor(16 - len, 0);
  lcd.print(surname);

  // ---- Row 1: only revert to voltage readings once the 1s IR window ----
  //             has actually expired AND a full two-digit entry was made
  if (showingIRResult) {
    if (secondDigit != -1 && millis() >= irDisplayUntil) {
      showingIRResult = false;
      firstDigit = -1;
      secondDigit = -1;
      // falls through to redraw the normal row below this frame
    }
  }

  if (!showingIRResult) {
    lcd.setCursor(0, 1);
    lcd.print(vBoth, 2);
    lcd.print("V");
    char oneStr[7];
    dtostrf(vOne, 5, 2, oneStr);
    lcd.setCursor(16 - (strlen(oneStr) + 1), 1);
    lcd.print(oneStr);
    lcd.print("V");
  }

  delay(200);
}

```