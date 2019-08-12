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
The gloves used in this project are just some basic glove liners from Amazon, made mostly from Polyester and some Spandex.  The heated fabric is some 15mm (Viscose) "Carbon Fiber" heating tape that was purchased online.  The tape claims to have a resistance of ~18Ω/m, so for
//
W of power per hand, a strip of 
//
was used with the power connection in the center to create two parallel strands.  Wires were attached to the conductive fabric using silver glue and then sewn in for maximum durability.

The heating fabric was simply glued down to the gloves using some waterproof Goop adhesive since everything else peeled off with little effort.  This was the only adhesive that remained flexible and allowed the fabrics to stretch with a closed fist.

// testing / issue with shorting

### Control Box ###
// waterproof 18650 box
// power duration calculations
// pcb design and such

## Results ##
While they may not look very pretty, the gloves are quite effective at warming hands during the cold negative temperatures.  They definitely met the initial design criteria, but there are a few flaws that should be fixed for a revision 2:
* The control box does not actually read the voltage level between the two batteries in series, even though the battery management IC supports it.  This can lead to unsafe discharge if a cell is compromised.
* Since the heating element is not insulated, touching any two parts of the fabric together causes a short.  During testing, the fabric began to smoke as it drew too much current while shorted out.  A current-limiting circuit is mandatory for revision two since the heating element is very close to contacting skin and could cause serious burns.  With the glove liners placed beneath an actual ski glove, this should not be an issue, but is still a safety concern.
* While the gloves are reasonably warm on the high setting, the other two modes are pretty much useless.  More power is required for adequate control over temperature.

{% include gallery.html id="heated-gloves" %}