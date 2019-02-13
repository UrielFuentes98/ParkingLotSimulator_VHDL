# ParkingLotSimulator_VHDL
This repository contains the design of a parking lot control system simulation in VHDL targeted to a Spartan 3 FPGA.

The simulaton consists of an FPGA, a LCD 20 * 2 screen and a servomotor. The LCD serves as the graphical interface to the user. It displays the main menu where the user can choose if he is going to enter or exit the parking lot. If the user enters the parking lot the LCD will show a code that acts as the parking lot ticket and then the servo turns 90º and comes back to simulate the entrance of the user. If the user is going to go out the parking lot, he is asked to enter his code, and afterwards the LCD displays the amount to pay and the time he spent inside the parking lot. 

The repository contains the following modules besides the main one = Estacionamiento.vhd
