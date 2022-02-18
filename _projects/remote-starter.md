---
title: IoT Remote Starter
image: remote-starter/thumbs/finished-top-case-front.jpg
status: Completed
date: 2018-01-01
---

After many frustrating winters with a one-way car starter, this two-way starter uses an always-connected GSM modem to make sure the car is warm.<!-- more -->

## Features ##
* SIM808 GSM module with GPS
* Custom PCB with 3D rendering (Altium Designer)
* Two CAN bus controllers for high and low speed
* Robust power supply to handle automotive transients

## Introduction ##
Many older cars had the luxury of a remote starter to warm things up during the cold Canadian winters.  Unfortunately, the remote keyfob had a single button and no indication of whether the car had actually started up or not.  Pressing the button a second time would cancel the remote start and shut the vehicle off.  The issue here is clear: without line-of-sight or any indication of the car starting successfully, did it start?  To solve this problem, rather than go out and purchase a two-way starter, I decided to build an internet-connected version using a small 2G modem and a $5/month data plan.

## Schematic ##
[![Schematic]({{ site.baseurl }}/assets/remote-starter/schematic.png "Schematic")]({{ site.baseurl }}/assets/remote-starter/schematic.pdf)

{% include gallery.html id="remote-starter" %}

## Results ##
I had great ambitions for this project to communicate over CAN and AWS IoT (MQTT), but once I got the prototype working reliably, I didn't continue investing the time.  This project was used for a couple winters and worked great.  I ran a web server in the cloud rather than finishing the AWS IoT functionality.  I later discovered the SIM7600 which had built-in support for SSL and MQTT and started playing around with it since it has an onboard application processor and would remove my need for the STM32 to handle SSL.  I didn't get too far before getting distracted by other projects.  I got a new vehicle in 2021 that can be started through CAN so I hope to revisit this project soon.