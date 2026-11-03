Here is your updated script. All rigid, absolute voltage numbers for the regulated outputs and solar slider adjustments have been removed and replaced with **live reading placeholders** (e.g., `[READ VM3 LIVE]`) and **approximation phrasing** (e.g., _"near our target"_, _"approximately"_).

  

This allows you to move the Tinkercad yellow solar slider naturally and read the exact numbers off your screen live during recording without stress.

  

### Pre-Recording Setup Checklist

1. **Solar Panel:** Set slider to full power (~20V position).
    
      
    
2. **3 Voltmeters Visible in Tinkercad Window:**
    
      
    - **VM1:** Connected across **Both Capacitors** (pin A0 node).
        
          
        
    - **VM2:** Connected across **Capacitor 1** (pin A1 node).
        
          
        
    - **VM3:** Connected across the **Load Potentiometer** (pin A3 node).
        
          
        
3. **IR Remote:** Placed near the IR receiver.
    
      
    
4. **Target Recording Duration:** ~4 minutes to 4 minutes 15 seconds (well within the 5-minute limit).
    
      
    

### Master Video Demonstration Script

#### PHASE 1: System Identification, Boot Sequence & Calibration (0:00 – 1:15)

- **WHAT TO DO:**
    
      
    1. Click **Start Simulation**.
        
          
        
    2. Point your cursor at the **Top-Right corner of the LCD**.
        
          
        
    3. Point your cursor at the **Top-Left custom character (`PA`)**.
        
          
        
    4. Hover your cursor across the **LCD voltage values** and compare them directly to the **3 Tinkercad Voltmeters**.
        
          
        
- **WHAT TO SAY:**
    
      
    
    > "Hello. In this video, I am demonstrating my FISA Solar Charge Controller circuit, which uses supercapacitors instead of batteries and dynamically switches between parallel and series modes.
    > 
    >   
    > 
    > Looking at the upper-right corner of the LCD, my surname 'Mtembu' is displayed.
    > 
    >   
    > 
    > Upon startup, the unenergized relay rests briefly in Series mode during hardware initialization. However, as soon as the Arduino code executes, it detects sufficient solar supply headroom and immediately switches the relay into Parallel mode for optimal charging. This is confirmed by the custom 'PA' character in the top-left corner of the LCD.
    > 
    >   
    > 
    > On row 1, the load voltage starts at 0.00V because no target has been set yet. On row 2, the LCD reads total capacitor voltage $v_{\text{both}}$ on the left and single capacitor voltage $v_{\text{one}}$ on the right.
    > 
    >   
    > 
    > Comparing our LCD values to the three multimeters: $v_{\text{both}}$ on the LCD matches Voltmeter 1 across both capacitors—currently reading `[READ VM1 LIVE]`—$v_{\text{one}}$ matches Voltmeter 2 across Capacitor 1—reading `[READ VM2 LIVE]`—and the load voltage matches Voltmeter 3 across the load potentiometer at `[READ VM3 LIVE]`. This confirms our software calibration is accurate to two decimal places. Furthermore, observing Capacitor 1 and Capacitor 2, their voltages are similar but not identical, reflecting real-time capacitor network balancing."
    > 
    >   
    
- **WHAT TO EXPECT ON SCREEN:**
    
      
    - **Initial Boot:** A quick transition as the software kicks in and switches to Parallel mode.
        
          
        
    - **LCD Row 0:** Displays `PA 0.00V Mtembu`.
        
          
        
    - **LCD Row 1:** Displays live capacitor readings.
        
          
        
    - **VM1 & VM2:** Display active capacitor network voltages.
        
          
        
    - **VM3 (Load):** Reads **0.00V**.
        
          
        

#### PHASE 2: IR Remote Entry & Control Loop Settling Time (1:15 – 2:30)

- **WHAT TO DO:**
    
      
    1. Click button **`3`** on the IR Remote.
        
          
        
    2. Click button **`2`** on the IR Remote.
        
          
        
    3. Hover your cursor over **LCD Row 1** for 1 full second.
        
          
        
    4. Move your cursor over **Voltmeter 3 (Load)** as the output voltage climbs and settles.
        
          
        
- **WHAT TO SAY:**
    
      
    
    > "Now I will adjust the target output voltage using the IR remote. I will set a target of 3.20V by pressing button '3' followed by button '2'.
    > 
    >   
    > 
    > As shown on the bottom line of the LCD, the screen temporarily displays `Input = 3.00V` after the first keypress, and then `Input = 3.20V` after the second. The system holds this overlay display for exactly 1 second before automatically reverting to live sensor telemetry.
    > 
    >   
    > 
    > Observing the top line of the LCD, our target of 3.20V is now active. Looking at Voltmeter 3 across the load, pin 5 adjusts its PWM duty cycle into the NPN transistor. As expected in closed-loop feedback control, the voltage experiences initial transient dampening due to capacitor charge lag before settling smoothly near our target at approximately `[READ VM3 LIVE]`. This value reflects discrete 8-bit PWM step resolution and satisfies our specification requirement for stable output regulation."
    > 
    >   
    
- **WHAT TO EXPECT ON SCREEN:**
    
      
    - **Upon pressing '3':** Bottom row temporarily shows `Input = 3.00V`.
        
          
        
    - **Upon pressing '2':** Bottom row updates to `Input = 3.20V`.
        
          
        
    - **After 1 second:** Bottom row reverts to live telemetry ($v_{\text{both}}$ and $v_{\text{one}}$).
        
          
        
    - **Top Row:** Displays `PA 3.20V Mtembu`.
        
          
        
    - **VM3 (Load):** Rises, dampens initial fluctuations, and stabilizes near the **~3.20V** target (read the exact value off VM3).
        
          
        

#### PHASE 3: Low Solar Parallel $\rightarrow$ Series Mode Switching (2:30 – 3:30)

- **WHAT TO DO:**
    
      
    1. State the exact switching condition verbally **before** touching the solar panel slider.
        
          
        
    2. Drag the **Tinkercad solar cell yellow slider down** until stored voltage drops below headroom threshold ($v_{\text{target}} + 0.40\text{V}$).
        
          
        
    3. Point your mouse at the **Relay contacts clicking** in Tinkercad.
        
          
        
    4. Point your mouse at the **LCD Top-Left Custom Icon** changing to `SE`.
        
          
        
    5. Point your mouse at **Voltmeter 1** and **Voltmeter 3**.
        
          
        
- **WHAT TO SAY:**
    
      
    
    > "Next, I will demonstrate automatic loss minimization by switching the capacitors from Parallel to Series mode.
    > 
    >   
    > 
    > The exact mathematical condition for switching from Parallel to Series mode is when the stored capacitor voltage $v_{\text{both}}$ drops below the target voltage plus a 0.40V headroom threshold—meaning $v_{\text{both}} < v_{\text{target}} + 0.40\text{V}$. With a 3.20V target, this threshold is approximately 3.60V.
    > 
    >   
    > 
    > To trigger this, I will simulate reduced sunlight by adjusting the solar cell slider downward in Tinkercad to drop the panel's output. As the available solar power drops, our total stored voltage falls below the threshold.
    > 
    >   
    > 
    > As seen on screen: pin 12 energizes the relay, and the LCD custom icon in the top-left changes dynamically from 'PA' to 'SE'. Voltmeter 1 confirms series stacking, which doubles the available terminal supply voltage. Because of this series voltage boost, Voltmeter 3 successfully maintains our regulated output near the target, currently reading approximately `[READ VM3 LIVE]` rather than collapsing."
    > 
    >   
    
- **WHAT TO EXPECT ON SCREEN:**
    
      
    - **Relay:** Switches state visually in Tinkercad.
        
          
        
    - **LCD Icon:** Top-left shifts from custom `PA` bitmap to custom `SE` bitmap.
        
          
        
    - **VM1 (Both Caps):** Drops to reflect series voltage division across the supply.
        
          
        
    - **VM3 (Load):** Held stably near the target (read the exact live value off VM3).
        
          
        

#### PHASE 4: Series $\rightarrow$ Parallel Return & Final Wrap-Up (3:30 – 4:15)

- **WHAT TO DO:**
    
      
    1. Drag the **Tinkercad solar cell slider back up** toward full power (~20V position).
        
          
        
    2. Point your cursor at the **LCD Top-Left Icon** shifting back to `PA`.
        
          
        
    3. Click IR buttons **`2`** then **`5`** to demonstrate a second target adjustment.
        
          
        
    4. Point at **Voltmeter 3** as it adjusts to the new target.
        
          
        
- **WHAT TO SAY:**
    
      
    
    > "To prove the system is fully reversible, I will restore solar power by sliding the solar cell output back up. Because supply headroom is restored ($v_{\text{both}} \ge v_{\text{target}} + 0.40\text{V}$), the Arduino de-energizes pin 12, flipping the relay back into Parallel mode. The top-left icon switches from 'SE' back to 'PA'.
    > 
    >   
    > 
    > Finally, I will enter a new target of 2.50V by pressing '2' then '5' on the IR remote. The 1-second overlay appears, and Voltmeter 3 systematically adjusts to regulate near the new 2.50V target, currently reading approximately `[READ VM3 LIVE]`.
    > 
    >   
    > 
    > This completes the full operational demonstration of our solar charge controller system. Thank you."
    > 
    >   
    
- **WHAT TO EXPECT ON SCREEN:**
    
      
    - **LCD Icon:** Shifts back from `SE` to `PA`.
        
          
        
    - **Bottom Row:** Shows `Input = 2.50V` overlay for 1 second.
        
          
        
    - **VM3 (Load):** Systematically adjusts to regulate near **~2.50V** (read live value off VM3).
        
          
        
    - **Total Duration:** ~4 minutes 15 seconds (Stop recording!)