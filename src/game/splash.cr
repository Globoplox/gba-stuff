require "../state"

class String
  def to_unsafe : UInt8*
    pointerof(@c)
  end
end

module Splash
  extend self
  include State
  @@i = -1

  # Back to initial id: image => bin => object + crystal binding (lib with const size and extern ref ? symbol must be defined in link file. This is an issue ?)
  #                                                              => we can try to define the symbol with objcopy. This way, no need for generating linker file.
  # This must be handled by the Makfile.
  # Hopefully it wont be as messy as previous, thanks to:
  # - crystal wildcard requires
  # - linker garbage collection
  # We can simply get all bmp in a directory, (maybe /assets)
  # transform them to object files (into /$build)
  # generate binding in /generated (have a symlink from src to it)
  # Drop in assets wont cause issues since we have both crystal and ld garbage collection ?
  
  
  # BASIC_TILESET = { { run "../compile_time/bmp_to_8bpp_tileset", "../basictiles.bmp" }}
  #BASIC_TILESET = { { `crystal src/compile_time/bmp_to_8bpp_tileset.cr src/basictiles.bmp` }}
  # StaticArray are not fit for blob storage
  WOLOLO = "456789AB" # This does not produce a blob of data, the constant string is put in rodata and then the const (in bss) is set to it, (proly by the crystal main)
  BASIC_TILESET = { # is this legal ?
    tileset: WOLOLO.to_unsafe.as(UInt16*),
    tileset_size: 4,
    palette: WOLOLO.to_unsafe.as(UInt16*),
    palette_size: 4,
  }
  
  def draw_init
    #GBA::Screen::Mode3.init
    
    # Both copy are inefficient, I know
    # Copy the palette
    c = 0
    while c < BASIC_TILESET[:palette_size]
      GBA::Screen::HAL.palette.backgrounds[c] = BASIC_TILESET[:palette][c]
      c &+= 1
    end

    # Copy the tileset
    t = 0
    while t < BASIC_TILESET[:tileset_size]
      GBA::Screen::HAL.vram.access_16b[t] = BASIC_TILESET[:tileset][c]
      t &+= 1
    end
    
    GBA::Screen::HAL.bg0cnt = GBA::Screen::HAL::BGCNT_COLOR_MODE | (8 << GBA::Screen::HAL::BGCNT_TILEMAP)
    GBA::Screen::HAL.dispcnt = GBA::Screen::HAL::DISPCNT_MODE_0 | GBA::Screen::HAL::DISPCNT_BACKGROUND_0
  end

  def call
    @@i = @@i &+ 1 if @@i < {{240 * 140}}
  end

  def draw
    # set ONE tile in the current drawn tilemap
    #((pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 8).as(UInt16*) + @@i).value = @@i.to_u16! # the most basic tilemap entry: index into the tilemap
    
    #GBA::Screen::Mode3[@@i] = 0x0ff0u16
  end
end
