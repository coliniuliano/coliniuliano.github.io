---
title: Trinkets (ESP8266)
image: trinkets/thumbs/rev5-pcb-bottom.jpg
status: ["v1: Completed", "v2: In-Progress"]
---

Trinkets are a low-power wireless development platform based on the ESP8266 Wifi module.  With out-of-the-box AWS IoT integration, Trinkets enable low-cost home monitoring.  Each unit is equipped with a magnet sensor, and comes configured as a door sensor by default.  An expansion port offers endless monitoring opportunities.<!-- more -->

## Features ##
* Espressif ESP8266 Wifi Module
* Microchip MCP73831 Li-Ion Charge Controller with Load Sharing
* Custom PCB with 3D rendering (Altium Designer)
* AWS IoT Integration
* Flexible and simple to program
* Fits Hammond 1551H enclosure

## Introduction ##
The Trinkets project was created to act as a basic home monitoring system.  By using expansion boards, many sensor designs were proposed and created: garage door open sensor (just a microswitch), laundry monitor (power measurement), soil moisture sensor (capacitve), and of course door and window sensors using a magnet.

## Hardware ##
The ESP8266 module is full of features and has an incredible amount of hobbyist support, making the hardware for this project quite simple.  Two areas of note are the load-sharing circuit, and the reset inhibitor circuit.

### Load Sharing ###
Since the MCP73831 battery charger IC does not claim to support load sharing, Q1, D1, and R1 ensure that the battery does not provide power to the circuit while it is being charged.  When USB power is provided, Q1 disconnects the battery from the rest of the circuit so that it can charge in isolation.  USB power flows through D1 to the rest of the circuit.

### Reset Inhibitor ###
To maintain low standby power, the ESP8266 module enable pin is usually held low until an event occurs (eg: a door opens).  Once the magnetic sensor is disengaged, or an external signal is present, the enable pin gets pulled high and the software starts running.  From a cold start, the software takes several seconds to establish an internet connection.  In earlier PCB revisions, the enable pin could return to a low state before the software had finished execution.  With the reset inhibitor, the software immdiately pulls GPIO14 high and prevents the module from entering a low power state until execution has finished.

{% include gallery.html id="trinkets" gallery="hardware" %}

### Schematic ###
[![Schematic]({{ site.baseurl }}/assets/trinkets/schematic.png "Schematic")]({{ site.baseurl }}/assets/trinkets/schematic.pdf)

## Firmware ##
Many different firmwares are available for the ESP8266 modules.  There is an Arduino port, a Lua interpreter, etc.  The current firmware is written in C since there is a very good AWS IoT example in the [esp-open-rtos](https://github.com/SuperHouse/esp-open-rtos) project.

{% include gallery.html id="trinkets" gallery="iot" %}