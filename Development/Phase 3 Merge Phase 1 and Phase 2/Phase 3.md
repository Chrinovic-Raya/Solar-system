```c++
#include <LiquidCrystal_I2C.h>
#include <Wire.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

const int relayPin = 12;
const int pinBoth = A0;  // C1(+) / Solar+  -> voltage over BOTH capacitors
const int pinOne  = A1;  // C2(+)           -> voltage over ONE capacitor
const int pinLoad = A3;  // not wired yet - load stage comes in a later phase

// Calibration factors = how much to multiply the pin's 0-5V reading by
// to reconstruct the real voltage at that divider's input.
float calBoth = 4.30; // (3.3k + 1k) / 1k
float calOne  = 4.30; // (3.3k + 1k) / 1k
float calLoad = 1.10; // (100 + 1k) / 1k - unused for now, A3 isn't connected

const char* surname = "Mtembu";

const unsigned long dwellTime = 5000; // ms per relay state
bool relayEnergized = false;
unsigned long lastSwitch = 0;

void setup() {
  Serial.begin(9600);
  lcd.init();
  lcd.backlight();

  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW); // start de-energized = SERIES

  lastSwitch = millis();
  Serial.println("Phase 3: relay + voltage sensing + LCD");
}

float readVoltage(int pin, float calFactor) {
  int raw = analogRead(pin);
  float pinVoltage = (raw / 1023.0) * 5.0;
  return pinVoltage * calFactor;
}

void loop() {
  // Non-blocking relay toggle - keeps the LCD/Serial refreshing continuously
  // instead of freezing for the whole dwell time
  if (millis() - lastSwitch >= dwellTime) {
    relayEnergized = !relayEnergized;
    digitalWrite(relayPin, relayEnergized ? HIGH : LOW);
    lastSwitch = millis();
  }

  float vBoth = readVoltage(pinBoth, calBoth);
  float vOne  = readVoltage(pinOne, calOne);
  // vLoad intentionally not read yet - A3 has nothing meaningful connected
  // until the pin-5 regulation stage exists
  // float vLoad = readVoltage(pinLoad, calLoad);

  Serial.print(relayEnergized ? "PARALLEL " : "SERIES   ");
  Serial.print("A0(both): "); Serial.print(vBoth, 2);
  Serial.print("V   A1(one): "); Serial.print(vOne, 2);
  Serial.println("V");

  // ---- Row 0: mode + (placeholder for load voltage) ..... surname ----
  lcd.setCursor(0, 0);
  lcd.print(relayEnergized ? "PA" : "SE"); // placeholder until custom chars exist
  lcd.print("--.--V"); // load voltage placeholder - not wired yet

  int len = strlen(surname);
  lcd.setCursor(16 - len, 0);
  lcd.print(surname);

  // ---- Row 1: both-capacitors voltage ..... one-capacitor voltage ----
  lcd.setCursor(0, 1);
  lcd.print(vBoth, 2);
  lcd.print("V");

  char oneStr[7];
  dtostrf(vOne, 5, 2, oneStr); // right-justified, width 5
  lcd.setCursor(16 - (strlen(oneStr) + 1), 1);
  lcd.print(oneStr);
  lcd.print("V");

  delay(200); // display refresh pace, not the relay's dwell timer
}
```