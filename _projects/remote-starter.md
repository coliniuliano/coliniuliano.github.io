---
title: IoT Remote Starter
image: remote-starter/thumbs/finished-top-case-front.jpg
status: Stalled
date: 2018-01-01
---

After many frustrating winters with a one-way car starter, this two-way starter uses an always-connected GSM modem to make sure the car is warm.<!-- more -->

## Stalled ##
This project was used for a couple winters and worked great.  I ran a web server in the cloud rather than finishing the IoT functionality.  I discovered the SIM7600 which had built-in support for SSL and MQTT and started playing around with it, but didn't get too far before distraction called.  I got a new vehicle in 2021 that can be started through CAN so I hope to revisit this project soon.

## Features ##
* SIM808 GSM module with GPS
* Custom PCB with 3D rendering (Altium Designer)
* ... more information to come

## Schematic ##
[![Schematic]({{ site.baseurl }}/assets/remote-starter/schematic.png "Schematic")]({{ site.baseurl }}/assets/remote-starter/schematic.pdf)

{% include gallery.html id="remote-starter" %}