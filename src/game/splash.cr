require "../state"

module Tilesets
  lib Basic
    $set_start = _binary_build_basictiles_tileset_bin_start : UInt32
    $set_size = _binary_build_basictiles_tileset_bin_size : UInt32
    $palette_start = _binary_build_basictiles_palette_bin_start : UInt16
    $palette_size = _binary_build_basictiles_palette_bin_size : UInt32
  end
end

module Splash
  extend self
  include State
  @@i = 0
  
  def draw_init
        
    # Both copy are inefficient, I know
    # Copy the palette
    c = 0
    while c < pointerof(Tilesets::Basic.palette_size).address.to_u32! >> 1
      GBA::Screen::HAL.palette.backgrounds[c] = pointerof(Tilesets::Basic.palette_start)[c]
      c &+= 1
    end

    # Copy the tileset
    t = 0
    while t < pointerof(Tilesets::Basic.set_size).address.to_u32! >> 2
      GBA::Screen::HAL.vram.access_32b[t] =  pointerof(Tilesets::Basic.set_start)[t]
      t &+= 1
    end
    
    GBA::Screen::HAL.bg0cnt = GBA::Screen::HAL::BGCNT_COLOR_MODE | (31 << GBA::Screen::HAL::BGCNT_TILEMAP)
    GBA::Screen::HAL.dispcnt = GBA::Screen::HAL::DISPCNT_MODE_0 | GBA::Screen::HAL::DISPCNT_BACKGROUND_0

    #GBA::Screen::Mode3.init
  end

  def call
    @@i = @@i &+ 1 if @@i < {{240 * 140}}
  end

  def draw
    # set ONE tile in the current drawn tilemap
    ((pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 31).as(UInt16*) + @@i).value = @@i.to_u16! # the most basic tilemap entry: index into the tilemap
    #GBA::Screen::Mode3[@@i] = 0x0ff0u16
  end
end
