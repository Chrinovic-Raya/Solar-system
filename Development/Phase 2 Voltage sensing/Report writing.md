


## Section: Explanation of Findings

Add this to describe what you tested and what you observed:

> During testing of the series/parallel switching, the LCD and Serial Monitor correctly showed the relay state along with voltage readings for both capacitors together (A0) and one capacitor individually (A1). Immediately after switching between modes, the readings matched theoretical expectations: approximately half the source voltage across each capacitor in series, and approximately the full source voltage across each capacitor in parallel.
> 
> However, when the relay was left in series mode for an extended period (over 60 seconds), the voltage across C1 was observed to rise steadily toward the full source voltage, while the voltage across C2 fell steadily toward 0V, rather than remaining stable at the expected ~10V split. This was confirmed using both the physical voltmeters placed across each capacitor and the Serial Monitor output over time.

## Section: Rectifications Based on Findings

This is the important one — explain the cause and your planned fix:

> **Problem identified:** In series mode, the junction between C1 and C2 has no direct resistive connection to the solar source — it is only reachable through C1 itself. Once C1 charges up, it stops conducting current (a charged capacitor blocks DC). However, the voltage-sensing resistor divider on A1 remains permanently connected from this junction to ground, providing a continuous discharge path. With current still able to leave the junction (through the A1 divider) but no current able to enter it once C1 is charged, the junction voltage drifts away from equilibrium: C1 charges further toward the source voltage while C2 discharges toward 0V.
> 
> **Rectification:** This matches the exact risk described in the project hints — that an imbalance between the two capacitors can drive one of them toward a voltage polarity outside what it is rated for. To resolve this, a voltage-balancing resistor will be added in parallel across each capacitor, sized to bleed a small, controlled current that keeps the two capacitors' voltages equalized regardless of the sensing circuit's own loading. This is addressed in Phase 3.2.

## Section: Circuit diagrams (Project and Data Design)

When you redraw your circuit diagram, add the balancing resistors across C1 and C2, and label them. This directly earns the rubric's **"Voltage balancing component" (1 mark)** line item, which otherwise has nothing in your circuit to satisfy it.

## Section: Calculations (optional but worth including)

Once you work out the actual balancing resistor value in Phase 3.2, add the derivation here alongside your divider calculations — it strengthens the calculations section even though it isn't one of the two explicitly graded calculation lines (output voltage, 20V voltages).

---

**Phase 3.2 scope**, to keep it separate and trackable in your dev notes: work out the balancing resistor value — this involves deciding how much bleed current is acceptable (small enough not to waste significant charge, large enough to dominate over the sensing divider's own imbalance effect), then picking the nearest E-12 value. Want to work through that calculation now?