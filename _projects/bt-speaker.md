---
title: Bluetooth "True Wireless Stereo" Speakers
image: bt-speaker/thumbs/square-front.jpg
status: In-Progress
---

Designed to experiment with True Wireless Stereo technology, these speakers feature the CSRA62415 audio module and BMR12 drivers wrapped in a modern oak enclosure.  Engineered for high-quality audio in a small form-factor, the signal path remains digital from the Bluetooth/USB input to the amplifier output.  Two speakers can be paired together to provide fully wireless stereo sound.<!-- more -->

## Features ##
* Qualcomm CSRA64215 Bluetooth Audio Module
* Maxim MAX98357A 3W Digital Amplifier
* HiWave BMR12 (Balanced Mode Radiator) 2" 8Ω Speaker
* Custom PCB with 3D rendering (Altium Designer)
* True Wireless Stereo technology
* Wireless charging

## Introduction ##
True Wireless Stereo technology enables two Bluetooth speakers to connect to each other and split the incoming audio signal into left and right channels.  In other words, TWS enables one speaker to act independently, or two speakers to pair together to provide completely wireless stereo sound.

This project was fabricated because it touches on several different engineering challenges: the woodworking needed to be visually appealing and tightly-integrated with the final electronics; the electronics needed to provide a high-quality audio signal and a strong Bluetooth connection; the firmware needed to ensure that a battery-pull is never required; and the overall design needed to look and sound incredible.  Many hours went into 3D modelling to ensure that the components would integrate tightly and still produce a crisp, deep sound.

## Hardware ##
The hardware for this project is quite simple since the CSRA64215 module is an all-in-one solution.  Most of the effort for this project went into messing around with all the poorly-documented configuration options available.  Many 2" speakers were tested for their sound quality to ensure that the final product could benefit from only the highest quality driver available.

{% include gallery.html id="bt-speaker" gallery="hardware" %}

### Schematic ###
[![Schematic]({{ site.baseurl }}/assets/bt-speaker/schematic.png "Schematic")]({{ site.baseurl }}/assets/bt-speaker/schematic.pdf)

## Woodworking ##
Each speaker is made of solid oak with contrasting espresso stain.  To ensure perfect fits, many templates were 3D-printed to assist with cutting.  Each speaker design was thoroughly 3D-modelled to guarantee adequate volume and seamless integration.

{% include gallery.html id="bt-speaker" gallery="wood" %}