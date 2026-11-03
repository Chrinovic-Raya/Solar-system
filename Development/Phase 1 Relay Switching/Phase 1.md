```c++
const int relayPin = 12;   // controls the transistor -> relay coil
const unsigned long dwellTime = 5000; // ms in each state - gives you time to read voltmeters

void setup() {
  pinMode(relayPin, OUTPUT);
  //digitalWrite(relayPin, LOW); // start de-energized = SERIES
  Serial.begin(9600);
  //Serial.println("Relay test started. LOW = series, HIGH = parallel");
}

void loop() {
  digitalWrite(relayPin, LOW);
  Serial.println("SERIES mode (relay de-energized)");
  delay(dwellTime);

  digitalWrite(relayPin, HIGH);
  Serial.println("PARALLEL mode (relay energized)");
  delay(dwellTime);
}
```