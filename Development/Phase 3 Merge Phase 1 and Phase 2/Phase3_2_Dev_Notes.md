---
tags:
  - embedded-systems
  - fisa
  - phase3-2
  - balancing-resistor
  - calculations
project: Replacing Batteries with a Substitute in a Solar System
phase: 3.2 — Voltage Balancing Resistors
status: complete
related:
  - - Phase3_1_Dev_Notes
---

# Phase 3.2 — Fixing the Series-Mode Voltage Drift with Balancing Resistors

# Circuit

[Phase 3.2](https://www.tinkercad.com/things/l71Uis2HyO4-phase-32)

## Scope of this phase
Work out and install a fix for the drift discovered in Phase 3.1: in series
mode, C1's voltage climbed toward the full source voltage while C2's voltage
collapsed toward 0V over time, instead of holding a stable ~50/50 split.

---

## What We Did

- Diagnosed the root cause precisely before designing a fix: the mid-node
  between C1 and C2 (C1−/C2+) has no resistive path back to the source once
  C1 is fully charged, since a charged capacitor blocks DC current. The A1
  sensing divider (3.3kΩ + 1kΩ = 4.3kΩ total), however, is permanently
  connected from that same node to GND — giving it a path *out* with nothing
  replacing the charge, so the node slowly drains.
- Worked out a balancing resistor value using the same divider-formula
  approach as Phase 2, adapted to solve for the point where a resistor's
  pull toward the source outweighs the sensing divider's pull toward GND.
- Chose a symmetric design — the same resistor value placed directly across
  both C1 and C2 — over an exact asymmetric solution, since it's simpler to
  justify in the calculations section for a small accuracy trade-off.
- Tested several E-12 candidate values against the target ~10V midpoint
  before settling on 220Ω.
- Wired one 220Ω resistor directly across C1's two terminals, and a second
  220Ω resistor directly across C2's two terminals — landing in the same
  breadboard columns as each capacitor's existing legs, so no new nodes were
  created.
- Re-ran the same extended-duration test from Phase 3.1 (relay held in
  series for over a minute) to confirm the drift no longer occurs, then
  checked parallel mode too, to make sure the new resistors didn't disturb
  behaviour that was already working.

---

## Calculations

**Setting up the problem:** at steady state, the mid-node sees three things
pulling on it: the balancing resistor from the source side, the balancing
resistor from the GND side, and the A1 divider's 4.3kΩ also pulling toward
GND. For a chosen balancing resistor value *Rb* on both sides:

```
V_junction = 20V × (Rb ‖ 4300Ω) / (Rb + (Rb ‖ 4300Ω))
```

**Candidates tested (target: 10V, the ideal 50/50 split):**

| Rb | Rb ‖ 4.3kΩ | V_junction | Deviation from 10V |
|---|---|---|---|
| 1kΩ | 811Ω | 8.96V | 10.4% |
| 330Ω | 305Ω | 9.60V | 4.0% |
| **220Ω** | **210Ω** | **9.77V** | **2.3%** |
| 100Ω | 97.7Ω | 9.88V | 1.2% |

**Chosen value: 220Ω**, symmetric across both capacitors. Close enough to a
clean 50/50 split to keep both capacitors well clear of any reverse-polarity
risk, without pulling as much continuous bleed current as the 100Ω option
would.

*(Note for the report: a more precise asymmetric pair — 820Ω on C1's side and
1kΩ on C2's side — would cancel the A1 divider's pull exactly and land on a
true 10.00V split. The symmetric 220Ω/220Ω pair was chosen instead for
simplicity, at the cost of a small, acceptable deviation.)*

---

## Results — Before and After

| Condition | C1 | C2 | Notes |
|---|---|---|---|
| Series, before fix, at switch | ~10.2V | ~9.76V | Looked fine momentarily |
| Series, before fix, after 60s | rising past 13.9V | falling below 1.3mV | Drift confirmed, uncorrected |
| Series, after fix, ~43s | 9.88V | 9.83V | Stable, balancing working |
| Series, after fix, later run | 10.1V | 9.61V | Still stable; small residual gap explained below |
| Parallel, after fix | 19.0V | 19.0V | Unaffected by the new resistors, as expected |

**On the small remaining gap (10.1V vs 9.61V) even with matched resistors:**
this isn't unexpected — the two sides of the mid-node aren't loaded
identically. C2's side still has the A1 divider (4.3kΩ) pulling extra
current toward GND that C1's side doesn't have an equivalent for, since A0
taps the source directly rather than through C1. This mismatch nudges the
split slightly off-centre, but the residual gap (under 5% of the pack
voltage) is small enough that both capacitors stay comfortably clear of
reverse polarity — which was the actual goal, not perfect symmetry to the
millivolt.

---

## Worth Mentioning in the Report

- **This whole phase is a direct answer to a hint given in the spec itself:**
  *"If the voltage difference between the two capacitors is too much, the
  capacitor with the lesser voltage can get a voltage polarity that is
  opposite of what the capacitor can handle."* Framing this section as
  solving that specific, named risk — not just "fixing a bug we found" —
  makes the calculations section land as intentional design work.
- **This also directly earns the "Voltage balancing component" rubric line**
  in the circuit diagram section (1 mark) — make sure the redrawn circuit
  diagram shows both 220Ω resistors clearly labelled across C1 and C2.
- **The before/after comparison is strong demonstration material.** The
  long-duration series test (drifting to near-0V before, stable ~9.7–10.1V
  after) is a clear, visual before/after that's easy to explain in the
  presentation video — show the drift happening once, then show it fixed.
- **The residual asymmetry (10.1V vs 9.61V) is worth explaining rather than
  hiding** — it shows understanding that the two capacitors aren't loaded
  identically by the rest of the circuit, and that "good enough to avoid the
  named risk" was the actual engineering target, not perfect symmetry.

---

## Changes Made and Why

| Change | Why |
|---|---|
| Added 220Ω resistor across C1 | Gives the mid-node a real, permanent path back toward the source, counteracting the drain caused by the A1 divider |
| Added 220Ω resistor across C2 | Completes the symmetric balancing pair, pulling the mid-node toward GND at a matched rate |
| Chose symmetric over exact asymmetric values | Simpler to derive and defend in the calculations section, for a small and acceptable accuracy trade-off |
| Re-tested both series and parallel after adding the resistors | Confirms the fix solves the series problem without breaking parallel behaviour that already worked |

---

## Next Steps
Move on to the NPN output-regulation stage on pin 5 and connect the 100Ω
potentiometer load, now that the capacitor bank holds a stable, predictable
voltage in both series and parallel modes.
