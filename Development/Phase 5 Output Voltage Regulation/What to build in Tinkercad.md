llStandalone: NPN transistor on pin 5, driven by feedback from the A3 reading, closed-loop control to hit a _hardcoded_ target voltage (0–4.3V range). Prove the regulation loop works before tying it to user input.


pHASE 5.1 

```C++
// ---- Phase 5 standalone test: NPN regulation + A3 feedback ----
// Load potentiometer confirmed at 100Ω per spec (not 1kΩ)

const int pwmPin = 5;     // NPN base, via 220Ω resistor
const int pinLoad = A3;   // feedback from the 100Ω/1kΩ divider on the emitter node

const float calLoad = 1.10; // (100 + 1000) / 1000 - same sensing divider as before,
                             // unaffected by the load pot's own value

void setup() {
  pinMode(pwmPin, OUTPUT);
  Serial.begin(9600);
  Serial.println("Phase 5 test: PWM sweep + A3 feedback");
  Serial.println("PWM\tRaw_A3\tV_A3\tV_Load(calc)");
}
void loop() {
  for (int pwmVal = 0; pwmVal <= 255; pwmVal += 25) {
    analogWrite(pwmPin, pwmVal);
    delay(100); // Allow output to settle

    // Take 20 samples over a ~40ms window to average out the PWM pulses
    long sum = 0;
    for (int i = 0; i < 20; i++) {
      sum += analogRead(pinLoad);
      delay(2);
    }
    int raw = sum / 20;

    float vA3 = (raw / 1023.0) * 5.0;
    float vLoad = vA3 * calLoad;

    Serial.print(pwmVal);
    Serial.print("\t");
    Serial.print(raw);
    Serial.print("\t");
    Serial.print(vA3, 2);
    Serial.print("V\t");
    Serial.print(vLoad, 2);
    Serial.println("V");
  }
  delay(2000);
}
```

phase 5.2

```c++
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

const int pwmPin = 5;       
const int pinLoad = A3;     
const float calLoad = 1.10;
const float targetVoltage = 3.00;

int pwmVal = 0;
float smoothedVLoad = 0.0; // Filtered voltage variable
unsigned long lastUpdate = 0;

void setup() {
  Serial.begin(9600);
  pinMode(pwmPin, OUTPUT);
  analogWrite(pwmPin, 0);

  lcd.init();
  lcd.backlight();
  lcd.clear();
}

void loop() {
  // --- 1. Continuous Sampling & Exponential Smoothing ---
  // Read 50 rapid samples across ~50ms to average out the 980Hz PWM ripple
  long sumLoad = 0;
  for (int i = 0; i < 50; i++) {
    sumLoad += analogRead(pinLoad);
    delayMicroseconds(500); // 0.5ms offset breaks PWM frequency harmonic alignment
  }
  
  float rawV = ((sumLoad / 50.0) / 1023.0) * 5.0 * calLoad;

  // Exponential Moving Average filter (80% previous reading + 20% new sample)
  if (smoothedVLoad == 0.0) smoothedVLoad = rawV; // First run initialization
  else smoothedVLoad = (smoothedVLoad * 0.8) + (rawV * 0.2);

  // --- 2. Closed-Loop Regulation using Smoothed Feedback ---
  if (targetVoltage <= 0.05) {
    pwmVal = 0;
  } else if (smoothedVLoad < (targetVoltage - 0.03) && pwmVal < 255) {
    pwmVal++;
  } else if (smoothedVLoad > (targetVoltage + 0.03) && pwmVal > 0) {
    pwmVal--;
  }
  
  analogWrite(pwmPin, pwmVal);

  // --- 3. Telemetry & LCD Updates (200ms interval) ---
  if (millis() - lastUpdate >= 200) {
    lastUpdate = millis();

    lcd.setCursor(0, 0);
    lcd.print("Target: "); lcd.print(targetVoltage, 2); lcd.print("V   ");

    lcd.setCursor(0, 1);
    lcd.print("Act: "); lcd.print(smoothedVLoad, 2); lcd.print("V P:"); lcd.print(pwmVal); lcd.print("   ");

    Serial.print("Target: "); Serial.print(targetVoltage, 2);
    Serial.print(" V | Actual A3: "); Serial.print(smoothedVLoad, 2);
    Serial.print(" V | PWM: "); Serial.println(pwmVal);
  }
}
```