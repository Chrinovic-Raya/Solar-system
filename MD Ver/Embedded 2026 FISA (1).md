Question 1
2026 Embedded Systems 3 FISA Project Specification

Replacing Batteries with a Substitute in a
Solar System

Relevant background information

 A solar system consist of solar panels, batteries and an “inverter” that controls and
interconnect the other subsystems. The “inverter” consist of an inverter and a solar charge
controller among other things. Solar power is becoming more popular for a variety of
reasons. Solar panels give electricity according to the amount of sunlight falling on it. If the
sun does not shine then the solar panels does not provide electrical energy.

The power provided, by the solar panels, then must be shared among the appliances. Thus,
appliances working on solar energy will have to share the available energy depending on the
household requirements and the availability of sunlight. If the sun does not shine then the
solar panels does not provide electrical energy. If more than enough electrical power can be
produced by the solar panels and the batteries is not fully charged then the extra energy is
used to charge the batteries. If more than enough energy can be produced by the solar
panels and the batteries is fully charged, then the extra energy goes to waste.

 If the solar panels is not providing enough energy then the batteries has to add the rest. For
example if the solar panels is delivering 1.8 kW and the household requires 2.2 kW then the
batteries has to provide the 0.4 kW that is still required. Thus, batteries are commonly used
to store electricity. The advantage of batteries is that as they run flat, the change in voltage
is firstly very slim. The problem with batteries is that they have a limited lifespan.

 As you can see with your cell phone, the more you discharge a battery the shorter the
lifespan is of the battery. Batteries are also expensive. Considering the price per kwh for
batteries and municipality, in some cases, using the batteries can be more expensive than
using municipal power. If the batteries are fully discharged and the solar panels is not
providing electricity, then the solar systems switch to the municipal power.

Instructions to students
 Your responsibilities are fourfold. Firstly, you are required to replace the batteries with
another component that basically have the same function as the batteries. Your project
focuses on the solar charge controller subsystem of the “inverter”. This solar charge
controller has to work with the component you suggested instead of the batteries.
 Secondly, your solar charge controller also must switch two of these components from
series to parallel and back to keep the losses as small as possible while still providing the
same output as can be expected from batteries.
 Thirdly, you must connect a Liquid-Crystal-Display to your solar charge controller, The
Liquid-Crystal-Display has to display similar information as shown in the picture below.

The first two characters in the upper left hand corner has to show if the components are in
series or parallel. Directly to the right of it the current output voltage must be
displayed. Thus, this is the voltage over the load. In the upper right-hand corner, the first
eight characters of your surname has to be shown. At the bottom-left, the voltage over both
components must be shown. On the bottom-right the voltage over one of the two
components must be shown. These voltages must be constantly read and displayed in real
time. Because the Arduino can accommodate a maximum of 5-volt, you must include
circuits that will let the Arduino read these high voltages.

 Fourthly, you must let the system use an infrared input to change the output voltage over
the load. If a value is pressed on the infrared remote, then then this value has to be
displayed on the bottom of the LCD screen. For example, if the value 3 is pressed then the
LCD screen should look as shown below.

After pressing the first button, the system should wait until the second button is
pressed. After the second button is pressed, the LCD should display the new desired output
value on the screen. For example, if the “2” button is pressed on the remote then the LCD
should show a display as shown below.

The LCD display should show this display for 1 second before returning to the normal
screen. Afterwards the output voltage over the load must be controlled to have the value
inserted. Thus in this example the output voltage must be controlled to be approximately
3.2V. The output voltage must be allowed to have a range from 0V to 4.3V.

Hardware

 You have to simulate the hardware as well as build the hardware. The simulated hardware
and the physical hardware are very much the same. Components that are commonly
available to connect to an Arduino must be used to emulate the components of this solar
charge controller. Thus, you have to use the most similar components.

•  Connect pin 3 to your infrared communication devices.
•  Use a relay to switch the capacitors from parallel to series and back.  You have to

choose the correct type of relay that will be able to do this.  You also have to use two
types of protection between the relay and the Arduino.  Use pin 12 to control the
relay.

•  For the physical circuit use a potentiometer as close to 100Ω as you can get hold of.
•  For the simulated hardware, use a 100Ω potentiometer to emulate the load

resistance.

•  The voltage on Tinkercad’s solar-cell must be changed to 20 V.
•  For the physical circuit, a power-supply in series with a variable resistor can be used

to emulate the solar-cell.

•  Keep in mind that the solar cell can deliver 20V will the maximum that the Arduino
can read is 5V.  Among other things, you can use 1kΩ resistors to overcome this
problem.  You will need to do calculations to determine the values for the other
components for this circuit.  As you can see in the rubric, the calculations will count
marks.  Use E-12 values.  Pin A0 must read the voltage over both capacitors.  Pin A1
must read the voltage over one of the two capacitors.  Pin A3 must read the output
voltage over the load.  Use an NPN transistor to regulate this output voltage.

•  Use pin 5 to influence the output voltage over the load.  Use the voltage reading to

keep the output voltage relatively the voltage required.
In simulation, place a voltmeter over one of the two capacitors.  Also, place a
voltmeter over both the capacitors.  A voltmeter should also be on the output.

•

1.

For the physical device, you will need to book out the components from the senior
technician (Mr. Wills). After constructing the circuit and taking a photo, take the components
back to the senior technician.

Hints

If the voltage difference between the two capacitors is too much then capacitor with the
lesser voltage can get a voltage polarity that is opposite of what the capacitor can handle.
When a capacitor is in parallel with a solar panel and the voltage on the solar panel is less
than the voltage over the capacitor then the solar panel consumes electricity instead of
supplying electricity.

Software

 All voltages displayed on the LCD must be correct to at least two decimal values. These
values must be calibrated. Thus, the values shown on the LCD display must correspond to
the readings on the voltmeters.

Responsibility

This is the second of two documents that you have to submit. The first document form is
the Graduate Attribute record. The Graduate Attribute document is the record that needs to
show your investigation into the project before you started while this document is to show
what you have accomplished.  The FISA mark, thus the mark for the project without the GA,
is T4 on MAS or OPA. You can extend the Graduate Attribute document to become the FISA
document.

1.  Picture of Simulated project:  Setup a circuit using Tinkercad.  It refers to the

simulation of the physical circuit.  In this way the program can be tested before the
physical device is build and programed.  Add a picture of the simulated circuit to the
FISA record.  The picture should be of such a nature that all components and
connections can be easily identifiable.  This picture of the simulation will contribute
10% to the FISA mark as indicated by the table below.  This table functions as the
rubric to the FISA project.

2.  Picture of Physical device:  Use an Arduino and other devices to create components
that forms part of the “solar charge controller”.  Add a picture of the physical circuit
to the FISA record.  The picture should be of such a nature that all components and
connections can be easily identifiable.  The picture of the physical device will
contribute to 10% of the FISA mark as indicated by the rubric below.  Keep in mind
that the marker cannot provide marks for things the marker cannot see.

3.  Software:  If the layout of the simulation corresponds to the layout of the physical
device, then the same software can be used for the simulation and the physical
device.  Add the code as text to the FISA record.  Do not add screenshots or pictures
of code to the document.  As shown in the table below, the software contributes 35%
of the FISA mark.

4.  Circuit diagram:  Create a circuit diagram for the simulated circuit.  Draw the circuit
diagram from scratch.  If you do not draw the circuit diagram from scratch, then
marks will be deducted.

5.  Calculations: various values must be calculated as shown in this document and in the

rubric.  The calculations contribute 5% to the FISA mark.

6.  Presentation:  Each student will have to make a PowerPoint presentation that is less

than 7 minutes in length of their projects.  Programs similar in function to
PowerPoint can also be used instead of PowerPoint.  The student has to make a
video of this PowerPoint presentation.  A single question will be asked online using
Blackboard.  The answer to this question will contribute to the marks for the
presentation as indicated in the rubric.  The presentation will contribute 10% to the
FISA mark.

7.  Demonstration of simulation:  Make a video of less than 5 minutes to demonstrate

your project.  Use a computer only to show the simulations.  The student will need to
know how to operate all the components of the solar charge controller.  It
contributes 10% to the FISA mark.

8.  Each student has to hand in a unique project.  If there are parts of the project that is
similar to another student’s project, then it will be considered as plagiarism, and
appropriate steps should be taken.

