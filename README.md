# Introduction

Garnet provides a framework for creating hardware designs that communicate with
a host system over PCI using the Xilinx VCU118 evaluation board.
It provides support for host-controlled DMA, a memory-mapped control interface,
board-to-host interrupts, partial reconfiguration of the user design (so no
re-enumeration of the PCI bus is needed, which can often require a reboot) and
access to the 2 x 2 GiB of on-board DDR 4 memory.
This design is heavily inspired by the FPGA Development Kit provided for Amazon
F1 instances, but simplified and adapted for the VCU118.

Building and modifying the shell requires Vivado 2019.1.

## Basic structure

```
garnet_top
|-- shell
|   |-- PCI_DMA
|   `-- shim
`-- partition_wrapper
    |-- partition
    |-- garnet_ddrs
    `-- debug_bridge
```

The `partition_wrapper` cell is the top level of the reconfigurable partition,
but is provided in `lib/partition_wrapper.v` and automatically used as the top
level wrapper by `tcl/build.tcl`.
The user-provided logic is placed in the `partition` cell.

# Using

Before using in a project, Garnet's IP used by `partition_wrapper` must be
generated with `make ip`.

A Tcl script is located in `tcl/build.tcl` that can be sourced to provide
helper functions rather than copying boilerplate.
Using the provided script also ensures the user project is not broken by
changes in the shell structure.

An example project is located in `example/`.
This project allows DMA to/from DDR A and disables DDR B.
It maps writes on the CTL interface to controlling interrupt requests, and
reads on the CTL interface to the number of interrupt ACKs received for that
IRQ, where IRQ `n` is located at address `4 * n`.
The project can be built with `make -C example` (or just `make` run from within
the project directory).

## Pre-built files

A pre-built shell is provided both for convenience and to allow
interoperability (given partial bitstreams can only be loaded if built using
the exact same shell checkpoint).
In `shell/prebuilt/` there are the following files:

- `empty.bit` - A full bitstream for the shell containing an empty partition.

- `empty_pblock_partition_partial.bit` - A partial bitstream for just the empty
  partition.

- `empty_primary.mcs`/`empty_secondary.mcs` - A copy of `empty.bit` able to be
  written to the on-board flash to avoid needing to reprogram after power loss.

- `shell.dcp` - A design checkpoint for the shell to be linked with
  a user-provided partition.

## Reconfiguring

The `xvsecctl` program from the [Xilinx reference drivers] can be used to
reconfigure the FPGA with a new partition.
For example, if connected on bus number 0x65 and device number 0x0, the
following will load the example partition:

```
xvsecctl -b 0x65 -F 0x0 -c 0x1 -p example/build/example_pblock_partition_partial.bit
```

The bus and device numbers for all Xilinx XDMA devices attached via PCI can be
found with `lspci -d 10ee:903f`, which will print one or more lines of the
form:

```
65:00.0 Serial controller: Xilinx Corporation Device 903f
```

# Interfaces

## Clocks

The shell provides a single 250 MHz clock.
All interfaces with the shell and DDRs are synchronous with this clock.
PLLs and MMCMs can be instantiated within the user logic as needed.

## DDR4 AXI

Garnet, being built for the VCU118, provides access to 2 x 2 GiB of DDR4
memory, exposed through the `DDRA_M_AXI` and `DDRB_M_AXI` interfaces.
These are 512-bit AXI4 interfaces with 6 ID bits and 64-bit addresses.
The memory controllers are instantiated by `lib/partition_wrap.v` in the
reconfigurable partition for better place and route results.
Each controller can be optionally disabled by setting `$disable_ddra` and
`$disable_ddrb` respectively to 1 when using `build.tcl`, or by defining
`DISABLE_DDRA` and `DISABLE_DDRB` respectively in `garnet_config.vh` if
manually creating the header.

## DMA_S AXI

Any DMA transactions performed by the XDMA block use the `DMA_S_AXI` interface.
This is a 512-bit AXI4 interface with 4 ID bits and 64-bit addresses.

## CTL AXI-Lite

The XDMA block is configured with a 32 MiB BAR0, intended for miscellaneous
communication.
This is exposed by the shell as the `CTL_S_AXI_LITE` interface.
This is a 32-bit AXI4-Lite interface with 32-bit addresses.

## Interrupts

16 user-controlled interrupt request lines, `irq_req[15:0]`, are provided by
the shell's XDMA block, though to allow them to be decoupled cleanly during
partial reconfiguration a shim presents a slightly different interface to that
of the XDMA block.
Interrupts are positive edge-triggered.
This is more permissive than the corresponding interface provided by the Amazon
F1 shell (which specifies single-cycle pulses); designs that wish to be
compatible with both should hold the line high for only a single cycle.
Each request will be acknowledged by the XDMA block asserting the corresponding
line in `irq_ack[15:0]` for a single cycle.
Only one outstanding request per interrupt line is supported; the user logic
must wait until the last interrupt has been acknowledged before requesting
another.

# Rebuilding the shell

Run `make shell-clean` to ensure a clean build directory then run `make shell`.
This will generate the Vivado project, build it, and copy the resulting
artifacts to `shell/prebuilt/`.

# Modifying the shell

Delete an existing build with `make shell-clean`, then `make shell-project`
will create the project (but not build it).
This project defines a block design for the shell (saved as
`shell/tcl/shell.tcl`), a completely empty partition module (in
`shell/src/empty.v`) and the top-level structure outlined at the start of this
document.
The project itself is generated by `shell/tcl/empty/project.tcl` and built by
`shell/tcl/empty/build.tcl`.
Constraints files for the shell itself are located in `shell/xdc/`.
Make any desired alterations, and then perform a _clean_ build as per the
previous section to ensure all changes have been correctly persisted.
Be sure to commit the updated `shell/prebuilt/` contents, as any partial
bitstreams are tied to the specific shell build they were linked with and thus
cannot be used without the empty non-partial shell bitstream.
Modifications to the shell itself should also be minimised where possible,
since a new shell requires loading a new non-partial bitstream, which may
require a reboot.

[Xilinx reference drivers]: https://github.com/Xilinx/dma_ip_drivers
