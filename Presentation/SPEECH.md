
### Slide 1

- **Speech Notes:**
    
      
    
    > "Good day. My name is Alwande Mtembu (Student Number: 230525598), and today I am presenting my final Embedded Systems 3 project at CPUT, titled: _Replacing Batteries with a Substitute in a Solar System_."
    > 
    >   
    

### Slide 2

- **Speech Notes:**
    
      
    
    > "To look at the background and objectives: traditional solar systems need energy storage when solar input is insufficient, but standard chemical batteries have chemical and maintenance limitations. To solve this, my project uses a capacitor bank as the storage element. Our main objectives are to store energy using capacitors, switch dynamically between parallel and series configurations, and provide a regulated output voltage selected by the user through an IR remote."
    > 
    >   
    

### Slide 3

- **Speech Notes:**
    
      
    
    > "Slide 3 outlines our core system architecture. The system uses a solar panel to provide input energy, a capacitor bank to store it, a relay to change the capacitor topology, an NPN transistor for output regulation, voltage dividers to scale system voltages safely for the Arduino, and an IR receiver with an LCD for user input and display."
    > 
    >   
    

### Slide 4

- **Speech Notes:**
    
      
    
    > "Slide 4 shows the overall system block diagram. It connects the 20V solar cell, capacitor bank, DPDT relay switch, and voltage dividers into a central power rail, managed by the Arduino Uno R3 using PWM control on Pin 5, relay switching on Pin 12, an IR receiver on Pin 3, and an I2C LCD display."
    > 
    >   
    

### Slide 5

- **Speech Notes:**
    
      
    
    > "This diagram shows the voltage sensing and display development stage. It highlights the voltage-divider resistor network connected to analog pins A0, A1, and A3, along with the Arduino UNO and the 16x2 LCD interface."
    > 
    >   
    

### Slide 6

- **Speech Notes:**
    
      
    
    > "This diagram details the capacitor storage and switching stage. It shows how the relay, capacitors, diodes, and associated power and protection components are wired together."
    > 
    >   
    

### Slide 7

- **Speech Notes:**
    
      
    
    > "This diagram covers the transistor control stage. It shows the additional transistor, resistor, and capacitor connections used to build the regulation circuit."
    > 
    >   
    

### Slide 8 (Phase 1)

- **Speech Notes:**
    
      
    
    > "In Phase 1, the purpose was to establish the basic energy-storage and switching circuit using a solar cell, two capacitors, and a relay. In parallel mode, capacitors share the path and operate at the same voltage, whereas in series mode, their voltages combine for a higher system voltage. The relay physically changes this connection, which was verified using initial serial and voltmeter checks."
    > 
    >   
    

### Slide 9 (Phase 2)

- **Speech Notes:**
    
      
    
    > "In Phase 2, we focused on safe telemetry and calibration. Because system voltages can reach up to 20V—which would harm the Arduino—we use three voltage-divider circuits on pins A0, A1, and A3 to reduce the voltage to a safe range. Software then converts these ADC readings back into calibrated system values, which are displayed live on the LCD."
    > 
    >   
    

### Slide 10 (Phase 3)

- **Speech Notes:**
    
      
    
    > "Phase 3 integrates telemetry with relay switching. The Arduino reads the capacitor voltages while controlling the relay, and the LCD displays these values in real time. As the relay moves between series and parallel, the voltage readings change instantly, confirming the electrical state."
    > 
    >   
    

### Slide 11 (Phase 4)

- **Speech Notes:**
    
      
    
    > "Phase 4 adds IR remote input capture. An IR receiver is connected to Arduino Pin 3. When a button is pressed, the software decodes the command and identifies the target voltage. The LCD temporarily displays this value as 'Input = 3.20V' for about one second before storing it, allowing the user to change targets without reprogramming."
    > 
    >   
    

### Slide 12 (Phase 5)

- **Speech Notes:**
    
      
    
    > "Phase 5 introduces closed-loop PWM regulation. An NPN transistor is controlled via PWM on Arduino Pin 5, and pin A3 provides output feedback. An Exponential Moving Average (EMA) filter smooths out rapid measurement fluctuations, allowing the Arduino to accurately compare the filtered voltage with the target and adjust the PWM from 0 to 255."
    > 
    >   
    

### Slide 13 (Phase 6)

- **Speech Notes:**
    
      
    
    > "Phase 6 is the final system merge. All tested subsystems combine into one complete system: the IR remote sets the target, voltage sensing provides feedback, the relay selects the topology, the NPN transistor regulates output using PWM, and the LCD displays the voltages, topology icons, and my surname, 'Mtembu'."
    > 
    >   
    

### Slide 14 (Switching Control Logic)

- **Speech Notes:**
    
      
    
    > "Slide 14 explains the switching control logic. The system switches to **SERIES** if the stored voltage is less than the target voltage plus 0.40V, because series operation increases available supply voltage and provides necessary regulator headroom. It remains in **PARALLEL** if the stored voltage is greater than or equal to target plus 0.40V, because parallel operation is retained when the required output can already be achieved."
    > 
    >   
    

### Slide 15 (System Verification & Demonstration)

- **Speech Notes:**
    
      
    
    > "System verification relies on three things: LCD state icons, LCD voltage dividers, and an independent physical voltmeter. During a demonstration, setting a target via the IR remote causes the LCD to display the input, the Arduino to evaluate the voltage and switch the relay if needed, and the NPN transistor to regulate the output via PWM, all confirmed by the physical meter."
    > 
    >   
    

### Results & Performance

- **Speech Notes:**
    
      
    
    > "In summary of our results, capacitors were successfully used as a battery substitute, supported by dynamic relay switching, accurate voltage measurement, user control via IR remote, and closed-loop PWM regulation."
    > 
    >   
    

### Scope & Limitations

- **Speech Notes:**
    
      
    
    > "Regarding scope and limitations, this prototype demonstrates capacitor storage and dynamic control for a small solar system, but it is constrained by component voltage and current ratings and is not meant to directly replace large commercial batteries."
    > 
    >   
    

### Conclusion

- **Speech Notes:**
    
      
    
    > "In conclusion, a solar-powered energy storage system using capacitors instead of conventional batteries was successfully developed, featuring dynamic series-parallel switching, safe monitoring, IR remote control, NPN PWM regulation, and complete LCD verification. Thank you for your time!"