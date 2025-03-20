# AHB-TO-APB-Bridge

## About the AMBA Buses

The Advanced Microcontroller Bus Architecture (AMBA) specification defines an on-chip communications standard for designing high-performance embedded microcontrollers. Three distinct buses are defined within the AMBA specification:

1.Advanced High-performance Bus (AHB)

2.Advanced System Bus (ASB)

3.Advanced Peripheral Bus (APB).

## Advanced High-Performance Bus(AHB)

The AMBA AHB is for high-performance, high clock frequency system modules. The AHB acts as the high-performance system backbone bus. AHB supports the efficient connection of processors, on-chip memories and off-chip external memory interfaces with low-power peripheral macrocell functions. AHB is also specified to ensure ease of use in an efficient design flow using synthesis and automated test techniques.

## Advanced System Bus(ASB)

The AMBA ASB is for high-performance system modules. AMBA ASB is an alternative system bus suitable for use where the high-performance features of AHB are not required. ASB also supports the efficient connection of processors, on-chip memories and off-chip external memory interfaces with low-power peripheral macrocell functions.

## Advanced Peripheral Bus(APB)

The AMBA APB is for low-power peripherals. AMBA APB is optimized for minimal power consumption and reduced interface complexity to support peripheral functions. APB can be used in conjunction with either version of the system bus.

The overall architecture looks like the following:

![image alt](https://github.com/shashankteli/AHB-TO-APB-/blob/7a50c3d4ba07ff52e2c1e6b33cc5626acfd1a6d7/Architecture.jpeg)

## Basic Terminology

### Bus cycle

A bus cycle is a basic unit of one bus clock period and for the purpose of AMBA AHB or APB protocol descriptions is defined from rising-edge to rising-edge transitions.

### Bus transfer

An AMBA ASB or AHB bus transfer is a read or write operation of a data object, which may take one or more bus cycles. The bus transfer is terminated by a completion response from the addressed slave. An AMBA APB bus transfer is a read or write operation of a data object, which always requires two bus cycles.

### Bus operation

A burst operation is defined as one or more data transactions, initiated by a bus master, which have a consistent width of transaction to an incremental region of address space. The increment step per transaction is determined by the width of transfer (byte, halfword, word). No burst operation is supported on the APB.

# Implementation

## Objective

To design and simulate a synthesizable AHB to APB bridge interface using Verilog and run single read and single write tests using AHB Master and APB Slave testbenches. The bridge unit converts system bus transfers into APB transfers and performs the following functions:

* Latches the address and holds it valid throughout the transfer.

* Decodes the address and generates a peripheral select, PSELx. Only one select signal can be active during a transfer.

* Drives the data onto the APB for a write transfer.

* Drives the APB data onto the system bus for a read transfer.

* Generates a timing strobe, PENABLE, for the transfer.

*Can implement single read and write operations successfully.

# Design modules

## AHB Slave Interface

An AHB bus slave responds to transfers initiated by bus masters within the system. The slave uses a HSELx select signal from the decoder to determine when it should respond to a bus transfer. All other signals required for the transfer, such as the address and control information, will be generated by the bus master.

## APB Controller

The AHB to APB bridge comprises a state machine, which is used to control the generation of the APB and AHB output signals, and the address decoding logic which is used to generate the APB peripheral select lines.


