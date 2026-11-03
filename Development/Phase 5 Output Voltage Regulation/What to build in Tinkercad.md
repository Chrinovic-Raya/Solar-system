llStandalone: NPN transistor on pin 5, driven by feedback from the A3 reading, closed-loop control to hit a _hardcoded_ target voltage (0–4.3V range). Prove the regulation loop works before tying it to user input.


```c++
//#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <IRremote.hpp>
LiquidCrystal_I2C lcd(0x27, 16, 2);

// Pins & Constants
const int relayPin = 12;
const int IR_PIN = 3;
const int pwmPin = 5;       // NPN transistor base (PWM control)
const int pinLoad = A3;     // Voltage feedback sensing pin
const int pinBoth = A0;
const int pinOne = A1;

const float calBoth = 4.30;
const float calOne = 4.30;
const float calLoad = 1.10; // Feedback calibration factor
const char* surname = "Mtembu";

// State Variables
const unsigned long dwellTime = 5000;
bool relayState = false;
unsigned long lastSwitch = 0, irUntil = 0;
int first = -1, second = -1;
bool showIR = false;

// Regulation Variables
float targetVoltage = 0.00; // Active setpoint voltage
int pwmVal = 0;             // PWM output (0 - 255)

// Decode raw 32-bit IR codes into numerical digits
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

float readV(int pin, float cal) { 
  return (analogRead(pin) / 1023.0) * 5.0 * cal; 
}

void setup() {
  Serial.begin(9600);
  lcd.init(); 
  lcd.backlight();
  
  pinMode(relayPin, OUTPUT); 
  digitalWrite(relayPin, LOW);
  
  pinMode(pwmPin, OUTPUT);
  analogWrite(pwmPin, 0);

  IrReceiver.begin(IR_PIN, ENABLE_LED_FEEDBACK);
  lastSwitch = millis();

  Serial.println(F("--- Phase 5.2 Closed-Loop IR Regulation ---"));
}

void loop() {
  // --- 1. IR Input Handling & Target Voltage Calculation ---
  if (IrReceiver.decode()) {
    int d = decode(IrReceiver.decodedIRData.decodedRawData);
    if (d >= 0) {
      if (first == -1) { 
        first = d; 
        targetVoltage = (float)first;
        lcd.setCursor(0, 1); 
        lcd.print(F("Input = ")); lcd.print(first); lcd.print(F(".00V   ")); 
        showIR = true; 
      } else if (second == -1) { 
        second = d; 
        targetVoltage = (float)first + ((float)second / 10.0);
        
        // Safety Ceiling
        if (targetVoltage > 4.30) targetVoltage = 4.30;
        
        lcd.setCursor(0, 1); 
        lcd.print(F("Input = ")); lcd.print(first); lcd.print(F(".")); lcd.print(second); lcd.print(F("V     ")); 
        irUntil = millis() + 1000; // Hold IR display message for 1 sec
        showIR = true;
      }
      
      Serial.print(F(">> Target Voltage Set To: "));
      Serial.print(targetVoltage, 2);
      Serial.println(F(" V <<"));
    }
    IrReceiver.resume();
  }

  // --- 2. Clear Temporary IR Display Overlay ---
  if (showIR && second != -1 && millis() >= irUntil) {
    showIR = false;
    first = second = -1; // Reset digits for next capture
  }

  // --- 3. Relay Toggle ---
  if (millis() - lastSwitch >= dwellTime) {
    relayState = !relayState;
    digitalWrite(relayPin, relayState ? HIGH : LOW);
    lastSwitch = millis();
  }

  // --- 4. Load Sensing with Multi-Sample Averaging ---
  long sumLoad = 0;
  for (int i = 0; i < 10; i++) {
    sumLoad += analogRead(pinLoad);
    delay(1);
  }
  float rawA3 = sumLoad / 10.0;
  float vA3 = (rawA3 / 1023.0) * 5.0;
  float vLoad = vA3 * calLoad;

  // --- 5. Closed-Loop NPN Regulation Controller ---
  if (targetVoltage <= 0.05) {
    pwmVal = 0;
  } else if (vLoad < (targetVoltage - 0.03) && pwmVal < 250) {
    pwmVal++; // Voltage too low -> open NPN transistor slightly
  } else if (vLoad > (targetVoltage + 0.03) && pwmVal > 0) {
    pwmVal--; // Voltage too high -> close NPN transistor slightly
  }
  analogWrite(pwmPin, pwmVal);

  // --- 6. Other Sensing Pins ---
  float both = readV(pinBoth, calBoth);
  float one = readV(pinOne, calOne);

  // --- 7. LCD Updates ---
  // Row 0: Relay State + Target Voltage + Surname
  lcd.setCursor(0, 0);
  lcd.print(relayState ? F("PA") : F("SE"));
  lcd.print(F(" "));
  lcd.print(targetVoltage, 1);
  lcd.print(F("V "));
  lcd.setCursor(16 - strlen(surname), 0);
  lcd.print(surname);

  // Row 1: Normal Voltages (when IR prompt is not active)
  if (!showIR) {
    lcd.setCursor(0, 1);
    lcd.print(vLoad, 2); lcd.print(F("V   ")); // Actual feedback voltage on A3
    char s[7]; 
    dtostrf(one, 5, 2, s);
    lcd.setCursor(16 - strlen(s) - 1, 1);
    lcd.print(s); lcd.print(F("V"));
  }

  // Serial Logging
  Serial.print(F("Target: ")); Serial.print(targetVoltage, 2); Serial.print(F("V | "));
  Serial.print(F("Actual Load (A3): ")); Serial.print(vLoad, 2); Serial.print(F("V | "));
  Serial.print(F("PWM: ")); Serial.println(pwmVal);

  delay(50);
}
```