# Game Boy Advance playground

This repostiory is my sandbox for playing with GBA. 
I'm doing it as much from scratch as I can because it is more intersting this way.  

I am using this  very cool guide [TONC](https://www.coranac.com/tonc/text/toc.htm) 
and the GBA hardware specs from there: [GBATEK](https://problemkaputt.de/gbatek.htm).
The startup file are mostly taken from [there](https://github.com/georgemorgan/gba/blob/master/gba.s), 
is is much simpler than the [devkitpro startup files](https://github.com/devkitPro/devkitarm-crtls/blob/master/gba_cart.ld), 
and I want to be able to understand eveyrthing I am doing.

# Dependencies

They should be available on every sane linux distro packages manager:
- [make](https://www.gnu.org/software/make/)
- [amr-none-eabi-gcc](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads)
- [llvm](https://llvm.org/)
- [crystal](https://crystal-lang.org/)

You migh also want a GBA emulator, I use [mgba](https://mgba.io/).
