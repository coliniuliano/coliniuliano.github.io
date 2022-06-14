---
title: Electronic Catan LCD Tiles
image: catan-tiles/thumbs/four-tiles.png
status: Completed
date: 2022-01-01
---

A collection of hexagon tiles that magnetically snap together to create a Settlers of Catan board of any shape or size. Each tile features a large round LCD and a custom magnetic pogo connector on each edge. Linking up a bunch of tiles creates a position-aware partial mesh network.<!-- more -->

## Features ##

* RP2040 microcontroller streams scanlines from flash with no framebuffer
* 2.1" 480x480 16-bit RGB round LCD with ST7701S driver (not SPI, only RGB)
* Tiles snap together with custom bidirectional magnetic pogo pin connectors
* Custom hexagon PCB using EasyEDA
* Hexagon enclosure 3D printed in 8000 resin

## Introduction ##

This is a project I've had in a sketch book for many years, but until recently, round LCDs were too expensive in an appropriate size for a Catan tile. In late 2021 I was looking through some old notes and the inspriation stuck again. I searched around and surprisingly didn't see anything quite like this, so I decided to build it myself as a fun covid project. I sourced some round LCDs for a decent price but they required an RGB driver and didn't have a framebuffer. With the chip shortage of 2021-22, the only microcontroller that could drive the RGB interface fast enough for under $5 was the RP2040, so the design requirements of this project practically wrote themselves. The tiles need to know which side their neighbouring tiles are on, so each edge needs to be individually addressed instead of just using a giant mesh network. Between the LCD's 16-bit interface + control signals, and the 6 edges for networking, this project uses every pin of the RP2040 and both cores to stream images from flash on-the-fly.

## Hardware ##

There is no schematic for this project since there were very few components and it was easy enough to just draw a PCB.

{% include gallery.html id="catan-tiles" gallery="hardware" %}

### Host Device ###

A host device injects power and controls the mesh network of tiles. It identifies the shape of the board by communicating with each tile independently through a broadcast mechanism, then generates a board in memory and broadcasts to each tile what resource and number it needs to become. I've experimented with using an ESP32 as the host so that it can include Wifi and Bluetooth as a way of configuring board parameters. In the interest of time, I didn't go down the rabbit hole of properly generating a legal game board, so the host randomly assigns a resource and number to each tile for this prototype.

### Magnetic Pogo Connector ###

While there are magnetic pogo pin connectors all over AliExpress, nothing really fit the bill for this project. Each tile needs six connectors, and a game needs at least 19 tiles, so cost is definitely a factor here. Each tile has six edges that need to distribute power, ground, and at least one data signal. There are no master or slave tiles, so the connectors need to be bidirectional so that a male pogo pin can mate with a female pin receiver. This leads to having two symmetrical sets of 3 pins per edge with power on the outer two, data in the next two, and ground in the center two pins.

{% include gallery.html id="catan-tiles" gallery="pogo" %}

## Firmware ##

### Scanline Video ###

The video scanline generation is very heavily based on the pico-playground [flash-stream example](https://github.com/raspberrypi/pico-playground/tree/master/scanvideo/flash_stream). Since the RP2040 does not have enough memory for a frame buffer, one whole core is used to generate scanlines on the fly. The renderer draws a background, then an alpha blended center marker, then the tile number on top.

## Networking ##

One of the most difficult parts of this project was the pseudo-mesh network protocol. In the game of Catan, two tiles that touch can not both have a "high" number like 6 or 8. In a normal mesh network, there is no way to determine the location of a node or its neighbours - there is just a single shared communication line and devices negotiate how they can access it. In order to generate a proper game board, there must be a way to determine the location of tiles relative to each other. To enable a host to determine the location of a tile and the overall board shape, rather than having one shared communication line, each side of each tile is separately addressable - so rather than one giant mesh network, a pseudo-mesh network is formed by a whole bunch of individual one-to-one connections. This way, each tile is able to detect its neighbours positionally and relay that information back to the host.

### OneWire ###

At the lowest level, the tiles communicate over a single data line using a modified OneWire protocol. Due to pin restrictions on the RP2040, with each tile edge requriing a separate data line, the communication between each pair of tiles is half-duplex. Rather than include external pull-up resistors for the communication lines, the protocol is just slowed down so that the internal resistors have a long enough time to return the line to its idle state.

### Pseudo-Mesh Protocol ###

There are many considerations when designing a network. For simplicity and reliability, data is relayed through a [flooding broadcast mechanism](https://en.wikipedia.org/wiki/Flooding_(computer_networking)) where each tile has a unique address. The unique address comes from the flash chip itself so there will never be any possible contention. Using a broadcast mechanism (as opposed to a routing mechanism) allows traffic to flow through the network of tiles without any consideration for whether there is an optimal or broken path between tiles. If a tile is abruptly disconnected for example, it should have no impact on the overall network and messages will continue to flow. A broadcast mechanism has its own downfalls too, like [broadcast storms](https://en.wikipedia.org/wiki/Broadcast_storm).

There are two types of message that can be sent through the network: a _direct message_ does not include an address and is meant for the tile that receives it; and a _broadcast message_ which is meant for the tile with a matching address. Tiles receiving a broadcast message will listen for a matching address, and if the address does not match, it will then begin to proxy the message on its other interfaces, creating a mesh network of sorts.

The basic protocol works as follows:

- The host device receives a trigger to probe/configure the board (typically a button press)
- The host device (H) sends a direct message to the tile it is attached to (T1), asking for that tile's ID. T1 responds directly to the host H with its tile ID. ![Protocol Step 1](/assets/catan-tiles/protocol/protocol-1.svg){: width="40%" }
- Host H is now only aware of Tile 1. H broadcasts a message to T1 to perform a "neighbour check". ![Protocol Step 2](/assets/catan-tiles/protocol/protocol-2.svg){: width="40%" }
- T1 sends a direct message to each of its 5 remaining interfaces (T2-T6), asking for those tiles' IDs. T2-T6 respond directly to T1 with their tile IDs. In this example, Tiles 2 and 3 respond.
![Protocol Step 3](/assets/catan-tiles/protocol/protocol-3.svg){: width="40%" }
- T1 is now aware of the tiles that surround it and which interface (side) they are physically on. T1 broadcasts a response to H describing the tiles surrounding it. Note that Tiles 2 and 3 will both receive the broadcast intended for the Host, and they will continue to broadcast it through the network until all nodes have received the message.
![Protocol Step 4](/assets/catan-tiles/protocol/protocol-4.svg){: width="40%" }
- H is now aware of T2-T6 and their position relative to T1. The cycle continues, host H broadcasts a message to T2 to perform a "neighbour check". The message will be broadcast to Tile 1, which will rebroadcast the message onto its other interfaces since it is not the intended recipient.
![Protocol Step 5](/assets/catan-tiles/protocol/protocol-5.svg){: width="40%" }
- Once the host H has identified all the tiles, it generates a board
- Once a board is configured, host H broadcasts a message to each tile and tells it what resource and number to display

## Results ##

This project went surprisingly well! There were many learning opportunities and struggles but the project was generally fun from start to "finish". The tiles work really well and the communication is fairly reliable. I need to work on the mesh networking aspect before the tiles can generate a proper game board, but that's a task for another time since I've accomplished as much as I care to for now.

{% include gallery.html id="catan-tiles" gallery="results" %}

### Version 2 ###

I likely won't bother with a version two since this was just for fun, but heres a list of some things I'd like to mess with if I do:
- Mesh network protocol: the communication is fairly reliable, but the code is sloppy and clobbers interfaces during broadcasts (ex: doesn't care if an interface is receiving/does not own the bus, it will try to broadcast anyway)
- Board generation: the tiles are just randomly generated right now; configuring a board with options like water, gold, etc is important
- Animated tile art: with a 16MB flash, it should be possible to store many images and rendering one per couple frames is trivial
- Compression: since the tiles are circular, the 480x480 background textures could be optimized to take up less space since many pixels are never drawn
- Dynamic refresh rate: some lines like the very center take longer to draw since there are more pixels to alpha blend, which reduces the frame rate; since the LCD hardware uses a DE pin for framing, a fixed frame rate is not necessary scanlines could take as long as they need
- Sprites, layers, optimizations: the center marker is crudely alpha blended and has a crude transparent drawing over top, both of which are very wasteful of cycles; another PIO can be used to draw sprites or the center marker, and there are certainly optimizations to be made
