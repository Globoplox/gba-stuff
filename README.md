# Game Boy Advance playground

This repostiory is my sandbox for playing with GBA.  
I'm doing it as much from scratch as I can because it is more intersting this way.  
I'm also doing it in [crystal](https://crystal-lang.org/) for the same reason.
  
I am using this  very cool guide [TONC](https://www.coranac.com/tonc/text/toc.htm)  
and the GBA hardware specs from there: [GBATEK](https://problemkaputt.de/gbatek.htm).
The startup file are mostly taken from [there](https://github.com/georgemorgan/gba/blob/master/gba.s).

# Dependencies

They should be available on every sane linux distro packages manager:
- [make](https://www.gnu.org/software/make/)
- [arm-none-eabi-gcc](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads)
- [llvm](https://llvm.org/)
- [crystal](https://crystal-lang.org/)

You migh also want a GBA emulator, I use [mgba](https://mgba.io/).  
As I write this, the rom work as expected in mgba but not in mgba-qt, which is weird.

Run `shards` to install crystal development dependencies.

# Usage
Just `make` it.

# Immediate TODO:
  - [ ] Basic string display system
  - [ ] Better assets handling
  - [ ] Maybe: find a way to reduce clutter without section-gcing `__crystal_main`.
  
# Credit

- [Tiny 16- Basic](https://opengameart.org/content/tiny-16-basic) by Lanea Zimmerman. [CC-BY 3.0](https://creativecommons.org/licenses/by/4.0/).
- [8x8 Font](https://github.com/dhepper/font8x8) by Marcel Sondaar, Public domain