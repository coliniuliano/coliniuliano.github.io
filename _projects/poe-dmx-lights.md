---
title: PoE+ DMX Lights for Live DJ Sets
image: poe-dmx-lights/thumbs/final-1.jpeg
status: In Progress
date: 2026-01-01
---

LED tube lights that synchronize a light show to a live DJ set. PoE+ provides up to 25W of power and streams data over one cable to reduce wiring complexity. Open source software reads timecode from Rekordbox to sync even while scratching on the decks. TouchDesigner software helps create really cool interactive shows.<!-- more -->

## Features ##

* Modified WLED using ArtNet or sACN (E1.31) on ESP32-S3
* W5500 ethernet controller
* Ag5700-LPB PoE+ module for 25.5W of power
* rkbx_link software ported to MacOS for sniffing data from Rekordbox
* 3D printed enclosure with 3 stacked PCBs

## Introduction ##

I've been attending large EDM music festivals for years. In 2025 a group of friends hosted their first annual camping trip where some people brought DJ equipment and performed live sets with lights and lasers. Later in 2025, I bought an AlphaTheta XDJ-AZ with a goal of participating in next year's show. I spent some weekends inviting friends over to play and I felt that having lights synchronized to the live sets would really elevate the whole experience.

In late 2025 I started exploring DMX lighting and solutions for synchronizing light shows to live DJ sets without having to preprogram shows, manually control things, or have a lighting expert. I discovered that there's really limited information about live synchronization and that really good software is locked away behind crazy expensive subscriptions. With a background in electronics and some really cool free software, I decided to take a shot at it myself.

## Hardware ##

This section will be updated as I complete rev2. In the meantime, just photos.

{% include gallery.html id="poe-dmx-lights" gallery="hardware" %}

<!--### Power over Ethernet ###

TODO: the Ag5700-LPB module, why PoE+ (25.5W) rather than passive PoE or a barrel
     jack, what the 25.5W actually buys in LED brightness, and which switch/injector
     is feeding them.

### Controller ###

TODO: the ESP32-S3 SuperMini and the W5500 module. Worth noting the S3 was chosen
     over a classic ESP32 for <reason>, and that the W5500 is wired to SPI3 on pins
     MISO 13 / MOSI 11 / SCLK 12 / CS 10 / IRQ 9 / RST 8.

### Enclosure ###

TODO: the 3D printed enclosure. Diffuser material, how the PCB stack mounts, how
     the RJ45 passes through, and anything learned about printing something this long. -->

## Firmware ##

The lights run a custom fork of WLED, which already speaks both Art-Net and sACN
(E1.31) and has a good effect engine for the times when nothing is driving it. What it did
not have was Ethernet on an ESP32-S3.

### W5500 with ESP32-S3 ###

WLED only supports RMII Ethernet, which relies on the EMAC peripheral built into the
classic ESP32. The S3 has no EMAC at all, so the Ethernet code refuses to compile for it.
A W5500 talks SPI instead and needs no EMAC, so the gap was never hardware — just that
nobody had taught WLED that Ethernet can arrive over SPI.

My first attempt at this was considerably uglier. The Arduino core of the day had no
support for SPI Ethernet chips, so it leaned on two libraries I had to fork and maintain
myself. Moving the project onto ESP-IDF 5 deleted both of them outright: the current
Arduino core drives a W5500 through exactly the same interface as the built-in Ethernet,
so the fork is now a much smaller change against stock WLED with no external dependencies
to keep alive.

The other half of the problem was addressing. These lights live on their own switch with
no DHCP server, and WLED would simply sit there unreachable waiting for one. I wanted both
behaviours — take an address from DHCP when there is a server, and assign itself a sane
one when there is not — so it now tries DHCP first and falls back to giving itself an
address derived from its MAC. In practice each light gets a static IP anyway, which comes
up faster and is easier to map to a DMX universe.

Doing that handover properly is the network stack's job, not the application's, and the
network stack can already do it — the feature just is not compiled into any stock Arduino
build. So I rebuilt the ESP-IDF framework itself with it enabled. That meant assembling a
complete toolchain in a container, working around a handful of upstream bugs along the
way, and carrying one patch for an ESP-IDF issue that is still open. The lights run that
build: the firmware simply asks for DHCP, and the network stack handles holding an
address until a lease shows up.

The firmware changes, the framework build and notes on how it all fits together are in my
[WLED fork](https://github.com/coliniuliano/WLED/tree/w5500-ethernet-autoip).

## Software ##

<!-- ### TouchDesigner ###

TODO: how the show is built. What drives the visuals (beat, BPM, audio analysis?),
     how universes map to lights, and whether cues are manual or fully automatic. -->

### rkbx_link ###

[rkbx_link](https://github.com/grufkork/rkbx_link) reads Rekordbox's memory directly to
pull out live track position, BPM and which deck is master, then forwards it over the
network. There is no official API for any of this, so it works by reading known memory
offsets, which move with every Rekordbox release.

It was Windows-only, so I added MacOS support and
[contributed it upstream](https://github.com/grufkork/rkbx_link/blob/master/data/offsets-macos).
Since the offsets change whenever Rekordbox updates, I find and publish the MacOS ones for
each new version so anyone else on a Mac can use it too.

## Results ##

<!-- TODO: how it performed in use. Latency from deck to light, how many fixtures ran
     at once, what broke. -->

This is revision one, and there are already a few things to fix for revision two. I'll update this page when its appropriate.

<!-- TODO: the revision 2 list. Keep it honest, as with the other projects here. -->

{% include gallery.html id="poe-dmx-lights" gallery="final" %}
