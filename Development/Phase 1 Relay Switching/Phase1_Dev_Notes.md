---
tags:
  - embedded-systems
  - fisa
  - phase1
  - relay
  - capacitors
  - solar
project: Replacing Batteries with a Substitute in a Solar System
phase: 1 — Relay + Protection + Capacitors + Solar Cell
status: complete
excalidraw-plugin: Pat
---

# Phase 1 — Relay-Based Series/Parallel Capacitor Switching

## Scope of this phase
Relay + two protection components + two capacitors + solar cell (20V). No LCD, no IR yet.
Goal: confirm the relay can reliably switch two capacitors between series and parallel,
verified with an LED/serial state confirmation and voltmeters across the capacitors.

---
## Circuits

- [Phase 1.1: Testing the SPDT RELAY](https://www.tinkercad.com/things/744FQzOOnGO-phase-11-relay-test)
- [Phase 1.2: Powering a SPDT Relay with a solar cell](https://www.tinkercad.com/things/jYaedfyWceZ-phase-12-relay-test-20v)
- [Phase 1.3: First attempt to achieve parallel and series switching with SPDT relay](https://www.tinkercad.com/things/e5bbCw2eOnq-phase-13-using-the-5v-spdt-relay)
- [Phase 1.4: Switching to using a DPDT relay](https://www.tinkercad.com/things/elJi1q5VKmF-phase-14-dpdt-relay-test-)
- [Phase 1.5: Succes](https://www.tinkercad.com/things/6yAYWkv6JLo-phase-15-using-the-5v-spdt-relay)
## What We Did

- Started with a bare relay driven by an NPN transistor, since the coil draws more
  current than an Arduino GPIO pin can safely source. The transistor acts as a
  low-side switch: Arduino pin → base resistor → base, with the coil sitting between
  the supply and the transistor's collector, and the emitter tied to ground.
- Confirmed relay state in code using serial prints (`SERIES mode` / `PARALLEL mode`)
  toggled on pin 12, and cross-checked visually with an LED tied to the relay's
  switched contact.
- Added a flyback diode directly across the coil terminals to absorb the
  back-EMF spike generated when the transistor switches the coil off.
- Established a shared ground between the coil-driving supply and the Arduino,
  since the transistor's base current needs a return path through Arduino GND —
  without this, the base-emitter junction never gets a stable reference and the
  transistor never turns on, regardless of the code.
- Swapped the coil's supply from a separate 9V battery to the Arduino's own 5V
  rail once we moved to a genuine 5V-coil relay, simplifying the driver circuit.
- Designed and wired the capacitor switching network:
  - **C1(+)** fixed to Solar+
  - **C2(−)** fixed to GND
  - **C1(−)** and **C2(+)** are the two terminals that move together via the relay
- Set Tinkercad's solar cell to 20V per the spec.
- Placed three voltmeters: one across each individual capacitor, and one across
  the whole two-capacitor block (Solar+ to GND) to track total pack voltage.
- Ran a toggling test sketch (LOW/HIGH on pin 12 with a dwell delay) and read
  all three voltmeters in both states to confirm the topology actually changes.

---

## Challenges and How We Overcame Them

**1. Relay coil not actually in the switched current path.**
Early on, tracing the schematic showed the transistor's collector wired straight
to the supply, with the coil's two terminals both landing on the ground rail —
meaning the coil would never see a voltage across it. Fixed by re-routing so the
coil sits directly in series between the supply and the collector.

**2. Diode wired with both leads on the same node.**
The first flyback diode placement had both leads landing on the same electrical
node (confirmed via Tinkercad's net-highlighting), so it never saw a voltage
difference and never conducted. Fixed by moving one lead to the coil's supply
side and the other to the collector side, so it's genuinely measuring the
voltage across the coil itself.

**3. Assuming a single SPDT relay could do full series/parallel switching.**
Working through the topology properly showed this doesn't hold up: series mode
only needs **one** new connection (bridging C1− to C2+), but parallel mode needs
**two** simultaneous connections (C1− to GND *and* C2+ to Solar+). A single throw
can only move one wire, so early single-pole designs either shorted a charged
capacitor to itself on switching, or created a floating loop with no ground
reference in "parallel" mode. Resolved by switching to a **DPDT relay** — two
poles, sharing one coil/one control signal, each pole handling one of the two
connections that need to move together.

**4. Misreading which voltmeter was measuring what.**
The "total voltage across both capacitors" meter initially read 0V in series and
20V in parallel — which looked like a fault, but was actually measuring across
the relay's own switched junction (COM1 to COM2), not across the capacitor pack.
Moved the probes to the pack's true outer terminals (C1+ / Solar+ to C2− / GND),
after which it correctly read a steady ~20V in both modes, since total pack
voltage doesn't depend on internal series/parallel arrangement.

**5. Establishing a shared ground.**
Realized that even though the battery/coil supply's high current never mixes
with the Arduino's own 5V/logic current, the transistor's small base current
does — and needs a return path back to Arduino GND. Verified with Tinkercad's
net-highlighting (clicking a wire shows every pin on the same electrical node)
rather than assuming continuity from the drawing alone.

---

## Why the Final Solution Works

The design keeps exactly two nodes permanently fixed — C1's positive terminal to
Solar+, and C2's negative terminal to GND — and only moves the two "inner"
terminals (C1− and C2+) together, using the DPDT relay's two poles:

- **De-energized (series, default):** Pole 1 ties C1− to C2+ (forming the series
  junction), Pole 2 confirms the same link. Result: Solar+ → C1 → C2 → GND, a
  proper series chain, each capacitor correctly forward-biased.
- **Energized (parallel):** Pole 1 ties C1− to GND, Pole 2 ties C2+ to Solar+.
  Result: both capacitors independently span Solar+ to GND — true parallel, both
  correctly forward-biased, no shorted or floating nodes in either state.

Because both poles are physically part of the same relay and move on the same
coil signal, the two required connection changes happen simultaneously and
reliably from a single Arduino pin — which is what the single-SPDT attempts
could never guarantee. The simulation results confirmed this: individual
capacitor voltages swing between ~10V (series, evenly split) and ~20V
(parallel, matching the source), while total pack voltage holds steady at
~20V regardless of mode — exactly the expected behaviour.

---

## Component Table

| Component | Quantity | Notes |
|---|---|---|
| Arduino Uno | 1 | Runs control logic, drives relay via pin 12 |
| DPDT relay (5V coil) | 1 | Switches C1− / C2+ between series and parallel wiring |
| NPN transistor | 1 | Low-side switch for the relay coil |
| Resistor (1kΩ) | 1 | Base current limiting resistor |
| Diode | 1 | Flyback protection across the coil |
| Capacitor (1000µF) | 2 | Battery substitute, switched between series/parallel |
| Solar cell (Tinkercad) | 1 | Set to 20V per spec, charging source |
| Voltmeter | 3 | One per capacitor, one across the full pack |
| LED (+ resistor) | 1 | Visual confirmation of relay/output state |
| Breadboard + jumper wires | — | Physical/simulated assembly |

---

## Why Each Component Was Used

| Component | Reason for Use |
|---|---|
| **Arduino Uno** | Only microcontroller in the spec; generates the control signal on pin 12 and will later handle sensing, LCD, and IR |
| **DPDT relay** | An SPDT relay can only make one switched connection, but true series↔parallel reconfiguration of two capacitors requires two connections to change at once (C1− and C2+). A DPDT relay's two poles, sharing one coil, do both simultaneously and reliably |
| **NPN transistor** | The relay coil draws more current than an Arduino GPIO pin can safely source; the transistor acts as a low-side switch so the Arduino only has to supply a small base current |
| **1kΩ base resistor** | Limits the current into the transistor's base, protecting both the transistor and the Arduino pin — one of the two required protection components |
| **Diode (flyback)** | Placed across the coil to absorb the voltage spike generated when the coil de-energizes, protecting the transistor from inductive kickback — the second required protection component |
| **Two 1000µF capacitors** | Act as the battery substitute; large capacitance chosen to store meaningful charge and give measurable, stable voltages during series/parallel testing |
| **Solar cell (20V)** | Explicitly required by the spec as the charging source; represents the real solar panel that would charge the batteries (now capacitors) |
| **Voltmeters (×3)** | Required to verify the switching actually changes the topology: two confirm individual capacitor voltages, one confirms total pack voltage stays consistent regardless of mode |
| **LED + resistor** | Gives a quick visual/serial confirmation of relay state during testing, without needing to open the code every time |

---

## Next Steps
Move on to the voltage-sensing circuit (resistor dividers for A0/A1/A3) and the
associated E-12 calculations, before adding the NPN output regulation stage,
LCD, and IR remote — in that order, so each new subsystem is debugged in
isolation.
