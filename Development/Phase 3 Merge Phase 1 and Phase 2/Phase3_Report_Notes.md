---
tags: [embedded-systems, fisa, phase3, report-writing]
project: Replacing Batteries with a Substitute in a Solar System
purpose: "Maps every report-worthy Phase 3 finding to its exact FISA template section, with drafted text and reasoning"
related: [[Phase3_1_Dev_Notes]], [[Phase3_2_Dev_Notes]]
---

# Phase 3 — Report-Worthy Findings & Where They Go

Each entry below: what happened, drafted text you can adapt into the report,
which FISA template section it belongs in, and why.

---

## 1. Why A1 taps C2, not C1

**→ Goes in: Methodology**
*("Explain which steps you have taken in the designing process.")*

**Draft text:**
> When deciding how to wire the "voltage over one capacitor" reading, C2 was
> chosen over C1 for a specific reason: C2's negative terminal is permanently
> fixed to ground in both series and parallel modes, so a simple divider
> measuring C2's positive terminal relative to ground genuinely represents
> C2's voltage in either state. C1 does not have an equivalent fixed
> terminal — both its terminals are either tied to the source or switched by
> the relay — so a divider on C1 alone would not give a meaningful single-
> capacitor reading.

**Why it goes here:** Methodology is where design *decisions* and the
reasoning behind them belong, not just a list of what was built. This shows
the choice was calculated from circuit theory, not arbitrary.

---

## 2. Rejecting an incorrect reference circuit before building it

**→ Goes in: Methodology**

**Draft text:**
> Before wiring the combined circuit, a candidate reference diagram was
> checked against circuit theory rather than assumed correct. Tracing what
> each relay position would do to the capacitor voltages revealed it would
> short-circuit one capacitor to itself on switching, wire two separate
> voltage readings to the same node (making them always identical), and
> omitted the required protection components entirely. The existing,
> already-verified design was kept instead.

**Why it goes here:** demonstrates a verification step in the design
process — exactly what Methodology is meant to capture, and it's evidence of
independent circuit analysis rather than copying a diagram.

---

## 3. Voltmeter and LCD readings confirming the series↔parallel switch

**→ Goes in: Explanation of findings**
*("Explain what was working and what was not working... how well did the
circuit work.")*

**Draft text:**
> Once the relay switching circuit and voltage-sensing circuit were
> combined, the LCD and Serial Monitor were checked against physical
> voltmeters through several full switching cycles. The "one capacitor"
> reading (A1) was confirmed to rise from approximately half the source
> voltage to nearly the full source voltage the moment the relay switched to
> parallel, and fall back on returning to series — while the "both
> capacitors" reading (A0) remained approximately constant throughout, as
> expected since it measures the fixed top and bottom of the whole pack
> rather than the internal arrangement.

**Why it goes here:** this is the direct evidence for several rubric lines —
"Voltmeter readings confirm parallel to serial switch" and the reverse — so
it belongs in Findings with the actual observed numbers, and the matching
screenshots should sit right alongside it.

---

## 4. The capacitor voltage drift discovery (series mode)

**→ Goes in: Explanation of findings AND Rectifications based on findings**
(split across both, as described below)

**Draft text for Explanation of findings:**
> When the relay was left in series mode for an extended period (over 60
> seconds), rather than the two capacitors holding a stable ~50/50 voltage
> split, C1's voltage was observed to rise steadily toward the full source
> voltage while C2's fell steadily toward 0V. This was confirmed with both
> physical voltmeters and the Serial Monitor over time, not just a single
> reading.

**Draft text for Rectifications based on findings:**
> This drift occurs because the junction between C1 and C2 has no resistive
> path back to the source once C1 is fully charged — a charged capacitor
> blocks further DC current, similar to a full tank with its inlet closed.
> However, the voltage-sensing divider on A1 remains permanently connected
> from that same junction to ground, continuously drawing a small current
> with nothing replacing it, so the junction voltage drains over time.

**Why it goes in both sections:** this is a genuinely accurate physical
description of why a passive resistive divider is a flawed way to monitor an
isolated capacitor node — and it's exactly the kind of finding the FISA
report wants: not just "it didn't work," but the correct circuit-theory
reason why, backed by repeated testing. Splitting it across both sections
matches what each section is actually asking for: Findings wants the
observed behaviour, Rectifications wants the diagnosis and cause.

---

## 5. The balancing resistor fix

**→ Goes in three places: Rectifications based on findings, Circuit
diagrams, and Calculations**

**Draft text for Rectifications based on findings:**
> Rather than only documenting the drift as a limitation, a fix was
> designed and implemented: a 220Ω resistor placed directly across each
> capacitor's terminals. This gives the junction node a permanent,
> dominant path toward a balanced voltage that overpowers the sensing
> divider's small drain, without requiring any redesign of the existing
> relay or sensing circuits. Retesting over the same extended duration
> confirmed both capacitors now hold stable voltages (approximately 9.6–10.1V
> each in series mode) instead of drifting toward the source voltage and 0V.

**Circuit diagram:** add both 220Ω resistors, clearly labelled, directly
across C1 and C2 in the redrawn diagram.

**Calculations section — derivation to include:**
> Target: hold the C1/C2 junction close to the ideal 10V midpoint despite the
> A1 sensing divider (4.3kΩ) pulling current from that node. Testing E-12
> resistor values against `V_junction = 20 × (Rb ‖ 4300)/(Rb + (Rb ‖ 4300))`
> showed 220Ω keeping the junction within ~2.3% of the ideal split, chosen
> over smaller values as a reasonable trade-off between accuracy and
> continuous bleed current.

**Why it goes in all three:** *your instinct to investigate rather than just
patch the resistor value and move on was the right call — treating the
balancing resistor as a real next step, rather than only writing it up as a
limitation, earns both the mark for identifying the problem in Findings and
the mark for actually solving it in the circuit diagram* (this is also a
direct, named rubric line: "Voltage balancing component," 1 mark). The
Calculations section needs the derivation regardless, since resistor-value
calculations are explicitly graded there.

---

## 6. This whole drift-and-fix story matches a hint given in the spec itself

**→ Goes in: Introduction (Problem statement) or Methodology — pick one
consistently**

**Draft text:**
> The specification itself warns that an excessive voltage difference
> between the two capacitors risks driving the lesser-charged one into a
> reverse polarity outside its rating. The drift discovered during testing
> is a direct, observed instance of exactly this risk, and the balancing
> resistor solution was designed specifically to address it.

**Why it goes here:** ties your own testing directly back to a stated
project risk, which strengthens the Problem Statement/Objectives framing —
it shows the project didn't just meet the literal instructions, it addressed
a risk the brief explicitly flagged.

---

## 7. The small residual imbalance after the fix (10.1V vs 9.61V)

**→ Goes in: Explanation of findings, and optionally Scope and Limitations**

**Draft text:**
> Even with matched 220Ω resistors on both capacitors, a small residual
> imbalance remains (observed as approximately 10.1V and 9.61V), because the
> two sides of the junction are not loaded identically — C2's side also
> carries the A1 sensing divider's load, which C1's side does not have an
> equivalent for. This gap is under 5% of the total pack voltage and keeps
> both capacitors well clear of any reverse-polarity risk, which was the
> actual design target rather than exact millivolt-level symmetry.

**Why it goes here:** reporting the remaining imperfection honestly, with
its correct cause, is stronger than implying a perfect fix — and if word
count allows, restating it briefly in Scope and Limitations ("the balancing
solution reduces but does not perfectly eliminate the imbalance") shows
awareness of the design's real boundaries.

---

## 8. Non-blocking timing fix for the relay/LCD

**→ Goes in: Rectifications based on findings, briefly**

**Draft text:**
> The initial combined sketch used `delay()` to hold each relay state, which
> would have frozen the LCD and Serial output for the entire dwell period
> between switches. This was changed to a `millis()`-based non-blocking
> check, so the display now refreshes continuously while the relay still
> switches on the same timer.

**Why it goes here:** a small but real bug that was found and fixed — worth
one or two sentences in Rectifications, doesn't need its own section.

---

## Quick reference — everything above, by section

| Report section | What goes there |
|---|---|
| **Introduction / Problem statement** | Item 6 (tie drift to the spec's own stated risk) |
| **Methodology** | Items 1, 2 (design reasoning + verification before building) |
| **Circuit diagrams** | Item 5's balancing resistors, labelled on C1 and C2 |
| **Calculations** | Item 5's resistor derivation |
| **Explanation of findings** | Items 3, 4 (findings half), 7 |
| **Rectifications based on findings** | Items 4 (cause half), 5, 8 |
| **Scope and Limitations** | Item 7 (optional restatement) |
