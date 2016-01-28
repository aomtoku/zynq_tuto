# CLI Design Flow for Zynq Tutorial

## Required Tool
 * Vivado 2015.4, Vivado SDK 2015.4
 * Digilent Zybo 
 * SD Card

## Design Flow
 
### Build 
```
$ cd boards/zybo/synthesis
$ make fetch 
$ make all
```

### Download
```
## Please insert a SD into your computer.
$ make sd-card
```

### Demo
```
## Please insert a SD into ZYBO
$ sudo screen /dev/ttyUSB1 115200

zynq>
```


