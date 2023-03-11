# Game Boy Advance playground
65;6800;1c
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
- [Crystal](https://crystal-lang.org/)

You migh also want a GBA emulator, I use mgba.

# Generated sources, assets and compilation

The GBA memory layout, memory mapped registers and resulting binary memory sections are defined 
in  `src/gba.ld`.  
Each image files in the `src` directory is assumed to be a tileset. At compile time, a tool will extract raw binary bitmap and palettes in 
`*.bin` files, in format that is ready for use in the GBA.  
Each of these `.bin` files are then 'compiled' into an object file whit the raw data dumped into an elf section named accordingly.  
Then a linker script `src/generated/assets.ld` is generated to handle placements of theses section in the resulting rom binary.  
Finally a header file `src/generated/assets.h` is generated to defines the various DATA and SIZE constants.  

So, if you put a `test.bmp` files in the `src` directory, you can then includes 
`"assets.h"` and access PALETTE_TEST_DATA, PALETTE_TEST_SIZE, TILESET_TEST_DATA, TILESET_TEST_SIZE.
The data format is ready for being copied as is into the GBA VRA.

Each source file (*.c, *.S) are compiled into a 
