
#### PHASE 1: System Identification, Boot Sequence & Calibration (0:00 – 1:15)


          
        
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
    > Comparing our LCD values to the three multimeters: $v_{\text{both}}$ on the LCD matches Voltmeter 1 across both capacitors—currently reading `[READ VM1 LIVE]` matches Voltmeter 2 across Capacitor 1—reading `[READ VM2 LIVE]`—and the load voltage matches Voltmeter 3 across the load potentiometer at `[READ VM3 LIVE]`. 
    > 
    > 
    > This confirms our software calibration is accurate to two decimal places. Furthermore, observing Capacitor 1 and Capacitor 2, their voltages are similar but not identical, reflecting real-time capacitor network balancing."
    > 
    >   
    


#### PHASE 2: IR Remote Entry & Control Loop Settling Time (1:15 – 2:30)


        
- **WHAT TO SAY:**
    
      
    
    > "Now I will adjust the target output voltage using the IR remote. I will set a target of 3.20V by pressing button '3' followed by button '2'.
    > 
    >   
    > 
    > As shown on the bottom line of the LCD, the screen temporarily displays `Input = 3.00V` after the first keypress, and then `Input = 3.20V` after the second. The system holds this overlay display for exactly 1 second before automatically reverting to live sensor telemetry.
    > 
    >   
    > 
    > Observing the top line of the LCD, our target of 3.20V is now active. Looking at Voltmeter 3 across the load, pin 5 adjusts its PWM duty cycle into the NPN transistor. As expected in closed-loop feedback control, the voltage experiences initial transient dampening due to capacitor charge lag before settling smoothly near our target at approximately `[READ VM3 LIVE]`. 
    > 
    > 
    > This value reflects discrete 8-bit PWM step resolution and satisfies our specification requirement for stable output regulation."
    > 
    >   
    

        

#### PHASE 3: Low Solar Parallel $\rightarrow$ Series Mode Switching (2:30 – 3:30)


- **WHAT TO SAY:**
    
      
    
    > "Next, I will demonstrate automatic loss minimization by switching the capacitors from Parallel to Series mode.
    > 
    >   
    > 
    > The exact mathematical condition for switching from Parallel to Series mode is when the stored capacitor voltage $v_{\text{both}}$ drops below the target voltage plus a 0.40V headroom threshold—meaning . With a 3.20V target, this threshold is approximately 3.60V.
    > 
    >   
    > 
    > To trigger this, I will simulate reduced sunlight by adjusting the solar cell slider downward in Tinkercad to drop the panel's output. As the available solar power drops, our total stored voltage falls below the threshold.
    > 
    >   
    > 
    > As seen on screen: pin 12 energizes the relay, and the LCD custom icon in the top-left changes dynamically from 'PA' to 'SE'.
    > 
	Voltmeter 1 confirms series stacking, which doubles the available terminal supply voltage. Because of this series voltage boost, Voltmeter 3 successfully maintains our regulated output near the target, currently reading approximately `[READ VM3 LIVE]` rather than collapsing."
    > 
    >   
  
#### PHASE 4: Series $\rightarrow$ Parallel Return & Final Wrap-Up (3:30 – 4:15)

- **WHAT TO SAY:**
    
      
    
    > "To prove the system is fully reversible, I will restore solar power by sliding the solar cell output back up. Because supply headroom is restored, the Arduino de-energizes pin 12, flipping the relay back into Parallel mode. The top-left icon switches from 'SE' back to 'PA'.
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
   