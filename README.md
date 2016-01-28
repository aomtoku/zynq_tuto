# zynq_tuto

## Required Tool
 * Vivado 2015.4, Vivado SDK 2015.4
 * Digilent Zybo 
 * SD Card

## Design Flow
 
```
$ cd boards/zybo/synthesis
$ make fetch 
$ make all
## Please insert a SD into your computer.
$ make sd-card
## Please insert a SD into ZYBO
$ sudo screen /dev/ttyUSB1 115200

zynq>

```

