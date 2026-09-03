---
tags: [embedded-systems, fisa, phase2, voltage-divider, lcd, calibration]
project: Replacing Batteries with a Substitute in a Solar System
phase: "2 — Voltage Dividers + LCD"
status: complete
related: [[Phase1_Dev_Notes]]
---
# Circuit 
[Phase: 2.1 ](https://www.tinkercad.com/things/917PEPEPJHm-phase-21)

# Phase 2 — Voltage Sensing (A0/A1/A3) + LCD

## Scope of this phase
Build the three voltage-divider circuits (A0, A1, A3) so the Arduino can safely
read up to 20V. Wire the LCD and get it printing raw/calibrated voltage values
for all three points. No relay logic yet — dividers driven from a potentiometer
fed by the solar cell, standing in for the real capacitor voltages until phase 1
and phase 2 are merged.

---

## What We Did

- Worked out the divider math from `Vout = Vin × R2/(R1+R2)`, using the spec's
  given 1kΩ as R2 in every case and solving for R1:
  - **A0 & A1** (up to 20V in): R1 = 3.3kΩ → tap reads ~4.65V at 20V in
  - **A3** (up to 4.3V in): R1 = 100Ω → tap reads ~3.91V at 4.3V in
- Built all three dividers on the breadboard, each as top resistor → tap point
  → bottom resistor → GND, with the tap wired to the Arduino.
- Wired an I2C LCD on SDA/SCL (A4/A5) rather than a parallel LCD, to avoid
  eating into the digital pins pin 12 and pin 5 will need later.
- Wrote a test sketch that reads each analog pin, converts the raw ADC value
  to a 0–5V pin voltage, then multiplies by a calibration factor to
  reconstruct the real source voltage — printed to both Serial and the LCD.
- Used a potentiometer wired across the solar cell (outer legs to Solar+ and
  GND) as an adjustable test source, feeding all three dividers from the
  wiper, so the readings could be swept and checked against physical
  Tinkercad voltmeters without needing the real capacitor circuit connected.
- Cross-checked every reading against voltmeters placed at the pot wiper
  (ground truth) and at each divider's tap point, adjusting calibration
  factors until the code's reconstructed voltage matched the true source.
- Cleaned up and merged the LCD code into the main sketch: removed leftover
  `pinMode()` calls carried over from an unrelated example, renamed the LCD
  object, and laid out the display per the spec (mode placeholder + load
  voltage top-left, surname top-right, both-capacitor voltage bottom-left,
  one-capacitor voltage bottom-right).

---

## Challenges and How We Overcame Them

**1. A3's divider tap wired to the wrong analog pin.**
The third divider's tap was plugged into A2 instead of A3. Caught by tracing
the wires back to the Arduino header in a screenshot — the spec only uses
A0, A1, and A3, so A2 should never have a wire on it at all. Fixed by moving
the wire over one pin.

**2. Testing A3 with a source far outside its intended range.**
Feeding A3's 100Ω/1kΩ divider from the same ~20V pot used for A0/A1 pushed its
tap point to over 16V — well past the 5V a pin can safely read. In simulation
this just showed up as a pin maxed out at 5.00V (giving a nonsense
"calibrated" reading of 21.50V); on real hardware this would risk damaging
the pin. Resolved by testing A3 separately with the solar cell turned down to
~5V, which happens to sit close to A3's real intended range (0–4.3V) anyway.

**3. A leftover incorrect calibration constant, separate from the hardware issue.**
Even after fixing the voltage range going into A3, the code still reported
~19V instead of ~5V. The divider hardware was reading correctly (confirmed
against a physical voltmeter at the tap) — the bug was `calLoad` still set to
4.30 (A0/A1's ratio) instead of 1.10 (A3's own 100Ω/1kΩ ratio). This was a
useful case of separating a hardware problem from a software one: the meter
told us the circuit was fine, which meant the bug had to be in the constant,
not the wiring.

**4. Confusing the multimeter reading with the Serial/LCD reading.**
These are two different numbers by design, not a bug: the multimeter shows
the real, physical (small, safe) voltage at the divider's tap; the Serial/LCD
value is that same reading mathematically scaled back up in code to represent
the original source voltage. Getting clear on this distinction was necessary
before calibration made sense — the check isn't "do these two numbers match,"
it's "does `tap voltage × calFactor` match the true source voltage."

**5. LCD code had unrelated leftovers.**
The starting LCD sketch included `pinMode(A2, INPUT)` / `pinMode(A3, INPUT)`
and an object named `serial_LDR`, both clearly carried over from an unrelated
LDR example. `analogRead()` doesn't require `pinMode` at all, and the object
name would have looked out of place in the final report. Cleaned up before
merging with the main sensing code.

---

## Why the Final Solution Works

Each divider trades off two things correctly: it drops the incoming voltage
low enough to stay within the Arduino's 0–5V ADC limit, while using a known,
calculable ratio so nothing is lost — the real voltage can always be
reconstructed in software. The A0/A1 dividers (3.3k/1k) are set up for
capacitor voltages up to 20V; the A3 divider (100Ω/1k) uses a much gentler
ratio because the load voltage only ever reaches ~4.3V and needs finer
resolution rather than heavy scaling.

The calibration factor in code is the inverse of the divider ratio, so
multiplying the safe pin reading by that factor reconstructs what the real
voltage must have been. Testing against physical voltmeters — one at the true
source, one at each tap — confirmed the reconstructed values track the real
voltage closely across the tested range, which is exactly what the spec
requires ("values shown on the LCD display must correspond to the readings
on the voltmeters").

---

## Component Table

| Component | Quantity | Notes |
|---|---|---|
| Resistor 3.3kΩ | 2 | Top resistor, A0 and A1 dividers |
| Resistor 1kΩ | 3 | Bottom resistor, all three dividers (spec-given value) |
| Resistor 100Ω | 1 | Top resistor, A3 divider |
| I2C LCD 16x2 module | 1 | Display, uses SDA/SCL rather than extra digital pins |
| Potentiometer | 1 | Temporary adjustable test source for this phase only |
| Solar cell (Tinkercad) | 1 | Feeds the pot, standing in for the eventual capacitor voltages |
| Voltmeter | 4 | One at the source/wiper, one per divider tap |

---

## Why Each Component Was Used

| Component | Reason for Use |
|---|---|
| **3.3kΩ resistors (×2)** | Paired with the spec's given 1kΩ, produces a ratio that safely scales a 20V input down to ~4.65V — comfortably under the 5V ADC ceiling |
| **100Ω resistor** | A3's input only reaches ~4.3V, already close to the safe range; a gentler ratio here preserves more resolution than reusing the 3.3k ratio would |
| **1kΩ resistors (×3)** | Given directly by the spec as the bottom resistor for every divider; other values had to be calculated around this fixed one |
| **I2C LCD** | Displays mode, output voltage, surname, and both capacitor voltages per the spec's exact layout, while only using two pins (SDA/SCL) instead of six+ for a parallel LCD |
| **Potentiometer** | Provides an easily adjustable test voltage so all three dividers could be swept and calibrated against real meter readings before the actual capacitor/relay circuit is reconnected |
| **Voltmeters (×4)** | Needed to separate hardware truth from software calculation — one confirms the real source voltage, the other three confirm each divider's physical tap voltage, both required to properly calibrate the code |

---

## Next Steps
Reconnect this sensing circuit to the phase 1 capacitor/relay circuit in place
of the test potentiometer, confirm A0/A1/A3 track the real capacitor and load
voltages through both series and parallel switching, then move on to the NPN
output-regulation stage on pin 5.
