---
title: Heated Gloves
image: heated-gloves/thumbs/finished-glove-tip.jpg
status: "Completed"
---

Providing up to 15W of heat, these carbon fiber wrapped gloves were constructed to withstand and combat the harsh Canadian ski season.  A custom waterproof control box provides 3 levels of warming power for comfortable hands in any weather.<!-- more -->

## Introduction ##
While heated gloves are readily available, they are generally quite expensive and often use some variation of Nichrome wire which does not spread heat very effectively.  Many commercial versions only power the back of the hand to improve circulation, but my use-case was more centered around keeping finger tips warm.  Using high quality 18650 batteries and carbon heating fabric allows even heat distribution and easy recharging.  With the gloves accepting 12v power, they can be used with almost any power adapter, including the cigarette lighter in a car.

## Hardware ##
While powered gloves are the main focus of this project, a control box was also built as a mechanism of monitoring battery levels and controlling output power.  The gloves expect to receive 8-12v power through a standard barrel jack, so they are perfectly suitable to be used without a power controller.  Alternatively, any standard 12v dimmer should work just fine.

### Gloves ###
The gloves used in this project are just some basic glove liners from Amazon, made mostly from Polyester and some Spandex.  The heated fabric is some 15mm (Viscose) "Carbon Fiber" heating tape that was purchased online.  Some research indicated that average heated gloves output approximately 7.5W per hand, and with a nominal battery voltage of 7.4V (two lithium batteries in parallel), the tape needed a resistance of  per hand.  Given a claimed resistance of ~18Ω/m, a strip of around 48" was used and powered from the center to behave like two 24" heating elements in parallel.  Wires were attached to the conductive fabric using silver glue and then sewn in for maximum durability.

The heating fabric was simply glued down to the gloves using some waterproof Goop adhesive since everything else peeled off with little effort.  This was the only adhesive that remained flexible and allowed the fabrics to stretch with a closed fist.

### Control Box ###
The control box started as a common waterproof 18650 box from AliExpress that already had three LEDs and a pushbutton on top.  When the button was pressed, the LEDs would show the remaining battery level.  Since the gloves needed some method of power control, rather than add an inline switch, the PCB in the battery box was replaced with a custom design.

The custom PCB uses a PIC12F1572 with the same pushbutton and LED configuration, but allows the button to be held to set the output power in three levels: (off), low, medium, or high.  There is no schematic because of the ridiculous simplicity of the overall circuit, which was thrown together super quickly as a test for my cheap PCB milling machine.

## Results ##
While they may not look very pretty, the gloves are quite effective at warming hands during the cold negative temperatures.  They definitely met the initial design criteria, but there are a few flaws that should be fixed for a revision 2:
* The control box does not actually read the voltage level between the two batteries in series, even though the battery management IC supports it.  This can lead to unsafe discharge if a cell is compromised.
* Since the heating element is not insulated, touching any two parts of the fabric together causes a short.  During testing, the fabric began to smoke as it drew too much current while shorted out.  A current-limiting circuit is mandatory for revision two since the heating element is very close to contacting skin and could cause serious burns.  With the glove liners placed beneath an actual ski glove, this should not be an issue, but is still a safety concern.
* While the gloves are reasonably warm on the high setting, the other two modes are pretty much useless.  More power is required for adequate control over temperature.

{% include gallery.html id="heated-gloves" %}