# ParkingLotSimulator_VHDL
This repository contains the design of a parking lot control system simulation in VHDL targeted to a Spartan 3 FPGA.

The simulaton consists of an FPGA, a LCD 20 * 2 screen and a servomotor. The LCD serves as the graphical interface to the user. It displays the main menu where the user can choose if he is going to enter or exit the parking lot. If the user enters the parking lot the LCD will show a code that acts as the parking lot ticket and then the servo turns 90º and comes back to simulate the entrance of the user. If the user is going to go out of the parking lot, he is asked to enter his code, and afterwards the LCD displays the amount to pay and the time he spent inside the parking lot. 

The repository contains the following modules besides the main one = Estacionamiento.vhd

Clk_20HZ.vhd - Generates a signal with the frequency needed to control the servomotor.

Cronometro.vhd - Counts time passed.

DebounceUsar.vhd - Debounces input signals from the push buttons.

LCD2.vhd - Shows the screen where the user enters the code.

LCD3.vhd - Shows the screen with the time spent inside the parking lot and the amount to pay.

LCD4.vhd - Shows the screen with the code of the new car to enter.

LCD5.vhd -  Shows the screen when the parking lot is full.

MOD24.vhd - Counts hours.

MOD60.vhd - Counts minutes and seconds.

Servo.vhd - Controls the movement of the servomotor.
