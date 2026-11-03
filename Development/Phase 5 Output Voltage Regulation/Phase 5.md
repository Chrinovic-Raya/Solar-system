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