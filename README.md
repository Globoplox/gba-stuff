# Game Boy Advance playground

This repostiory is my sandbox for playing with GBA.  
I'm doing it as much from scratch as I can because it is more intersting this way.  

I am using this  very cool guide [TONC](https://www.coranac.com/tonc/text/toc.htm) 
and the GBA hardware specs from there: [GBATEK](https://problemkaputt.de/gbatek.htm).
The startup file are mostly taken from [there](https://github.com/georgemorgan/gba/blob/master/gba.s), 
is is much simpler than the [devkitpro startup files](https://github.com/devkitPro/devkitarm-crtls/blob/master/gba_cart.ld), 
and I want to be able to understand eveyrthing I am doing.

# Dependency
They should be available on every sane linux distro packages manager:
- [make](https://www.gnu.org/software/make/)
- [amr-none-eabi-gcc](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads)

You migh also want a GBA emulator, I use mgba. 

# Usage
I suspect that the only people that are going to look at this repository are friends that might not be used to bare metal programming
(well me neither) so here are some explaination:

## [gba.ld](https://github.com/Globoplox/gba-stuff/blob/master/gba.ld) 

It is a linker script. It tells the linker (the program that take all the object files and merge them into a single object).  
We are doing bare-metal programming, which mean we tell the toolchain (compiler, linker, whatever)  
not to assume anything about the hardware the code is going to run.   
The linker script allow us to control this.
Currently, the linker script includes: 
  - The memory mapping (which mempry addresses ranges map to which hardware components)
  - The definitions of various symbols (named addresses if you prefer) for important stuff
    - I/O register (GBA use [memory mapped I/O](https://en.wikipedia.org/wiki/Memory-mapped_I/O))
	- Stacks addresses
	- Expected interrupts handler location
  - Which elf object sections (named bunch of instructions / data) will end up in the address space at runtime
    (for example, when booting a regular gba cart, the bios will jump to `0x08000000`, which map to the actual cart rom memory.
    So we tell the linker that our code must be located at `0x08000000`.


## [startup.S](https://github.com/Globoplox/gba-stuff/blob/master/src/startup.S) 

It is an assembly source file.  
I expect to use mostly C for toying around, but for some things we need more control over exactly what we do.  
For example, the GBA Bios will check for a specific header data at the start of the ROM.  
Also, there is some setup to perform before we run C code: we need to set the stack address.  
So that is, the startup file is the place where GBA / ARM / C specific stuff is written in a way that allow fine control 
(such as name of the elf section the code will be located in, instruction set (Thumb or Arm), direct register interaction). 
