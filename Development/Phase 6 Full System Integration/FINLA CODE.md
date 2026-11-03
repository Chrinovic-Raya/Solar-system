```C++
#include <IRremote.hpp>
#include <LiquidCrystal_I2C.h>
#include <Wire.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

// --- Custom LCD Character Bitmaps (5x8 pixels) ---
// Series Symbol (Slot 0): End-to-end series node icon
byte seriesIcon[8] = {
  0b00000,
  0b11111,
  0b00100,
  0b01110,
  0b00100,
  0b11111,
  0b00000,
  0b00000
};

// Parallel Symbol (Slot 1): Dual parallel branch icon
byte parallelIcon[8] = {
  0b00000,
  0b11111,
  0b10101,
  0b10101,
  0b10101,
  0b11111,
  0b00000,
  0b00000
};

// Hardware Pin Definitions
const int relayPin = 12;      // Relay driver (LOW = Series, HIGH = Parallel)
const int IR_PIN = 3;         // IR Receiver pin
const int pwmPin = 5;         // NPN Transistor Base PWM
const int pinBoth = A0;       // Both capacitors voltage sensor
const int pinOne = A1;        // Single capacitor voltage sensor
const int pinLoad = A3;       // Regulated Load feedback sensor

// Calibration Factors & Metadata
const float calBoth = 4.30;
const float calOne = 4.30;
const float calLoad = 1.10;
const char* surname = "Mtembu";

// State & Timing Control Variables
bool relayState = false;       // false = Series (SE), true = Parallel (PA)
unsigned long irUntil = 0;
unsigned long lastLcdUpdate = 0;

// IR Input Tracking
int first = -1;
int second = -1;
bool showIR = false;

// Closed-Loop Regulation Control Variables
float targetVoltage = 0.00;
bool targetSet = false;        // Tracks whether an IR target has been entered
float smoothedVLoad = 0.0;
int pwmVal = 0;

// IR Code Lookup Table (Standard Tinkercad Remote)
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

// Analog Voltage Reader with Calibration Factor
float readV(int pin, float cal) {
  return (analogRead(pin) / 1023.0) * 5.0 * cal;
}

void setup() {
  Serial.begin(9600);
  
  // Hardware Pin Modes
  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW); // Start in Series mode for safety
  
  pinMode(pwmPin, OUTPUT);
  analogWrite(pwmPin, 0);

  // Initialize LCD Display
  lcd.init();
  lcd.backlight();
  lcd.clear();
  
  // Load Custom Circuit Symbols into LCD Character Memory
  lcd.createChar(0, seriesIcon);
  lcd.createChar(1, parallelIcon);

  // Start IR Receiver
  IrReceiver.begin(IR_PIN, ENABLE_LED_FEEDBACK);
}

void loop() {
  unsigned long currentMillis = millis();

  // =========================================================================
  // 1. PHASE 4: IR REMOTE DECODING & TARGET VOLTAGE ENTRY
  // =========================================================================
  if (IrReceiver.decode()) {
    int d = decode(IrReceiver.decodedIRData.decodedRawData);
    if (d >= 0) {
      if (first == -1) {
        first = d;
        targetVoltage = (float)first;
        showIR = true;
      } else if (second == -1) {
        second = d;
        targetVoltage = (float)first + ((float)second / 10.0);
        
        // Hard Safety Ceiling (Phase 4 Specification)
        if (targetVoltage > 4.30) targetVoltage = 4.30; 
        
        targetSet = true;               // Lock in target for regulation & display
        irUntil = currentMillis + 1000; // Hold input overlay for 1 second
        showIR = true;
      }
    }
    IrReceiver.resume();
  }

  // Clear IR Overlay Display Timer
  if (showIR && second != -1 && currentMillis >= irUntil) {
    showIR = false;
    first = second = -1; // Reset digit flags for next entry
  }

  // =========================================================================
  // 2. PHASE 1: CONDITIONAL LOSS-OPTIMIZING RELAY SWITCHING
  // =========================================================================
  // Read current total voltage stored across the capacitor bank
  float vBoth = readV(pinBoth, calBoth);

  // Loss Minimization Condition:
  // If stored voltage drops below target + regulator headroom (0.40V),
  // switch to SERIES (Relay LOW) to boost overall supply voltage.
  // Otherwise, remain in PARALLEL (Relay HIGH) to minimize internal conduction losses.
  if (targetSet && (vBoth < (targetVoltage + 0.40))) {
    relayState = false; // SERIES mode
  } else {
    relayState = true;  // PARALLEL mode
  }
  digitalWrite(relayPin, relayState ? HIGH : LOW);

  // =========================================================================
  // 3. PHASE 5: CLOSED-LOOP NPN REGULATION (EMA Filtered PWM Control)
  // =========================================================================
  // Microsecond sampling loop across 50 samples to eliminate PWM pulse aliasing on A3
  long sumLoad = 0;
  for (int i = 0; i < 5; i++) {
    sumLoad += analogRead(pinLoad);
    delayMicroseconds(100); 
  }
  float rawV = ((sumLoad / 5.0) / 1023.0) * 5.0 * calLoad;

  // Exponential Moving Average (EMA) smoothing
  if (smoothedVLoad == 0.0) smoothedVLoad = rawV;
  else smoothedVLoad = (smoothedVLoad * 0.5) + (rawV * 0.5);

  // Closed-Loop PWM Adjustment
  if (!targetSet || targetVoltage <= 0.05) {
    pwmVal = 0;
 } else if (smoothedVLoad < (targetVoltage - 0.03) && pwmVal < 255) {
  pwmVal += 5;
  if (pwmVal > 255) pwmVal = 255;
} else if (smoothedVLoad > (targetVoltage + 0.03) && pwmVal > 0) {
  pwmVal -= 5;
  if (pwmVal < 0) pwmVal = 0;
}
  analogWrite(pwmPin, pwmVal);

  // =========================================================================
  // 4. PHASE 2/3: NON-BLOCKING LCD TELEMETRY & DISPLAY REFRESH (200ms)
  // =========================================================================
  if (currentMillis - lastLcdUpdate >= 200) {
    lastLcdUpdate = currentMillis;

    float one = readV(pinOne, calOne);

    // --- ROW 0: Custom Symbol + Mode + Target Voltage + Surname ---
    lcd.setCursor(0, 0);
    if (relayState) {
      lcd.write(1);          // Custom Parallel Icon
      lcd.print("PA ");
    } else {
      lcd.write(0);          // Custom Series Icon
      lcd.print("SE ");
    }
    
    if (targetSet) {
      lcd.print(targetVoltage, 2); // Printed to 2 decimal places per rubric
      lcd.print("V");
    } else {
      lcd.print("--.--");
    }

    lcd.setCursor(10, 0);     // Right-aligned surname column
    lcd.print(surname);

    // --- ROW 1: IR Input Overlay OR Live Sensor Voltages ---
    lcd.setCursor(0, 1);
    if (showIR) {
      if (second == -1) {
        lcd.print("Input = "); lcd.print(first); lcd.print(".00V   ");
      } else {
        lcd.print("Input = "); lcd.print(first); lcd.print("."); lcd.print(second); lcd.print("V     ");
      }
    } else {
      // Clear line buffer to eliminate ghost digits
      lcd.print("                "); 
      
      lcd.setCursor(0, 1);
      lcd.print(vBoth, 2);
      lcd.print("V");

      lcd.setCursor(11, 1);
      lcd.print(one, 2);
      lcd.print("V");
    }
  }
}
```