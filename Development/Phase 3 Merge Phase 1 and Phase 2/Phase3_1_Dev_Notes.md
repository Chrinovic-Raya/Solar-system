---
tags: [embedded-systems, fisa, phase3-1, relay, voltage-sensing, lcd]
project: Replacing Batteries with a Substitute in a Solar System
phase: "3.1 — Merging Relay Switching with Voltage Sensing + LCD"
status: complete
related: [[Phase2_Dev_Notes]]
---

# Phase 3.1 — Combining the Relay Circuit with Sensing + LCD

# Circuit

[Phase 3.1](https://www.tinkercad.com/things/curUfShTeIJ-phase-31)

## Scope of this phase
Combine the relay switching circuit (phase 1) with the voltage-sensing/LCD
circuit (phase 2). The LCD should show live voltages while the relay switches
series↔parallel, with the readings visibly changing to reflect the switch —
this is a key rubric item, so proving it on camera/screenshot matters as much
as getting the wiring right.

---

## What We Did

- Removed the potentiometer test source from phase 2 and connected the real
  A0 and A1 dividers to the actual capacitor circuit from phase 1.
- Wired **A0's divider to C1(+) / Solar+** — this point never moves regardless
  of relay state, so it correctly represents the total voltage across both
  capacitors together.
- Wired **A1's divider to C2(+) / relay COM2** rather than C1 — reasoned out
  from first principles: C2(−) is permanently fixed to GND, so C2(+)'s
  voltage relative to GND *is* a clean single-capacitor reading in both
  modes. C1 doesn't have an equivalent GND-referenced terminal, since both of
  its terminals are either fixed to the source or switched — so it wouldn't
  give a meaningful "one capacitor" reading.
- Left A3 disconnected from anything real for now, since the load/regulator
  circuit doesn't exist yet (that's a later phase) — printed a placeholder on
  the LCD instead of a fabricated number.
- Rewrote the relay-toggle timing to be non-blocking (`millis()`-based)
  instead of using `delay(dwellTime)` inside the relay logic. The original
  test code would have frozen the LCD for the entire dwell period between
  switches; the new version keeps the display refreshing continuously while
  the relay still only flips every 5 seconds.
- Added the relay's live state ("SERIES"/"PARALLEL") to both the Serial print
  and as a placeholder character pair on the LCD's top-left corner.
- Verified, using both physical voltmeters and the Serial Monitor together,
  that A1's reading visibly climbs from roughly half the source voltage to
  nearly the full source voltage the moment the relay switches to parallel,
  and drops back down when it returns to series — while A0 stays roughly
  constant throughout, as expected.

---

## Problems We Faced and How We Fixed Them

**Problem: an AI-generated reference diagram looked plausible but was wrong
in three separate ways.** It wired A1 to the same node as A0 (which would
make them always read identically, defeating the point of having two
separate readings), it used a single-pole relay with a wiring pattern that
would short-circuit C1 the moment it energized, and it dropped the
transistor/diode protection circuit entirely.

*How we caught it:* rather than trusting the diagram, we traced through what
each relay position would actually do to the capacitor voltages, node by
node. That made the short-circuit and duplicate-reading problems obvious
before any wiring was touched.

*Fix:* kept our own already-verified design — DPDT relay, C1(+) fixed to
Solar+, C2(−) fixed to GND, C1(−) and C2(+) on the relay's two poles, A1
tapping C2(+) specifically, and the transistor + diode still in place between
the coil and pin 12.

**Problem: an LCD freeze during relay switching.** The first version of the
combined sketch used `delay(dwellTime)` to hold each relay state — this
would have frozen the LCD (and Serial output) for the whole 5-second window,
making it look like the display wasn't updating at all.

*Fix:* switched to checking elapsed time with `millis()` inside `loop()`
instead of blocking with `delay()` for the relay logic. The display now
refreshes every 200ms regardless of what the relay is doing, so the voltage
change is visible happening in real time rather than jumping between two
frozen screens.

**Problem: the "one capacitor" reading (A1) doesn't stay put — it slowly
drains toward 0V in series mode.** Left running for about a minute, C2's
voltage kept falling well past the expected ~10V, eventually reaching
essentially 0V, while C1 climbed the opposite direction toward the full
source voltage.

*In simple terms:* a charged capacitor stops letting current through it,
similar to a full water tank with the inlet valve closed. In series mode,
C2's node is only fed *through* C1 — so once C1 fills up, no more current
comes in from that side. But our own A1 measuring circuit is still quietly
draining a little current out of that same node the whole time, with nothing
replacing it. Over time, that node simply empties out.

*Status:* this is being fixed properly in **Phase 3.2** with balancing
resistors placed directly across each capacitor — documented separately
since it's a distinct piece of design work with its own calculations.

---

## Changes Made and Why

| Change | Why |
|---|---|
| A1 moved from a test pot to C2(+), not C1 | Only C2 has a GND-referenced terminal, making it the only capacitor a simple divider can cleanly measure in both series and parallel |
| A0 kept on C1(+)/Solar+ | Always represents the pack's total voltage, which is what "both capacitors" means, regardless of internal arrangement |
| Relay timing switched from `delay()` to `millis()` | `delay()` would block the LCD from updating during the entire dwell period; `millis()` lets both run independently |
| Rejected the AI-generated wiring diagram | It reintroduced an already-solved short-circuit bug, duplicated A0 onto A1, and dropped the required protection components |
| A3 left disconnected with a placeholder | Nothing real to measure yet — wiring it to an unrelated node would produce a meaningless number rather than an honest placeholder |

---

## Worth Mentioning in the Report

- **The rubric-critical proof is solid:** both the physical voltmeters and
  the LCD/Serial readings visibly and correctly change in sync with the
  relay switching — this directly satisfies the "voltmeter readings confirm
  parallel to serial switch" and "confirm serial to parallel" rubric lines,
  and is worth screenshotting for both directions.
- **The decision to wire A1 to C2 instead of C1 is genuine calculated
  design reasoning, not a guess** — worth explaining in the Methodology or
  Circuit Design section, since it shows understanding of why a plain
  resistive divider needs a GND-referenced terminal to give a meaningful
  reading, rather than just following a diagram.
- **The capacitor drain finding is exactly the risk the spec's own hint
  warns about** ("if the voltage difference between the two capacitors is
  too much, the capacitor with the lesser voltage can get a voltage polarity
  that is opposite of what the capacitor can handle"). This is strong
  material for the "Explanation of findings" and "Rectifications based on
  findings" sections — it shows a real problem was found through testing,
  correctly diagnosed, and not just patched blindly.
- **Rejecting a plausible-looking but incorrect circuit reference** is worth
  a line in Methodology too — it demonstrates verifying a design against
  circuit theory rather than assuming a diagram is correct because it looks
  detailed.

---

## Next Steps
Phase 3.2: work out and install the balancing resistors across C1 and C2 to
stop the series-mode drain, then confirm both capacitors hold stable voltages
over an extended period in both series and parallel modes.
