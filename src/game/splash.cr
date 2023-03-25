require "../state"

# module Tilesets
#   lib Basic
#     $set_start = _binary_build_basictiles_tileset_bin_start : UInt32
#     $set_size = _binary_build_basictiles_tileset_bin_size : UInt32
#     $palette_start = _binary_build_basictiles_palette_bin_start : UInt16
#     $palette_size = _binary_build_basictiles_palette_bin_size : UInt32
#   end
# end

# Make it a macro, make the generated bindings easier to use,
# add load simple routine (maybe mater dma one idk how it works yet)
# Make the tiles 4bpp (this mean: checking no tile has more than 16 color, and all color used by tiles must be in a 16 block, and if many blocks in palette,
# they must be 16b aligned).

# HOW TO: for each tile, generate a palette? Must not exceed 16 entries.
# Make a group of tile for each tile, linked to the palette.
# FOr each group (currenly of one tile), merge it into the first group whose palette is a superset of the current.
# Then, take the group with the biggest palette, and try to find the biggest group that could fit if merged (a_pal_size + b_pal_size - common_pal_size <16).
# repeat until one pass happen without any merge. (could work by generating permutation and testing them until one good is found, then retrying)
# Now you have n group, each with their palette.
{{ `crystal ./src/compile_time/assets_links.cr minimal` }}

module Splash
  extend self
  include State
  @@i = 0
  
  def draw_init
        
    # Both copy are inefficient, I know
    # Copy the palette
    c = 0
    while c < pointerof(Assets::Minimal.pal_size).address.to_u32! >> 1
      GBA::Screen::HAL.palette.backgrounds[c] = pointerof(Assets::Minimal.pal_start)[c]
      c &+= 1
    end

    # Copy the tileset
    t = 0
    while t < pointerof(Assets::Minimal.set_size).address.to_u32! >> 2
      GBA::Screen::HAL.vram.access_32b[t] =  pointerof(Assets::Minimal.set_start)[t]
      t &+= 1
    end
    
    GBA::Screen::HAL.bg0cnt = GBA::Screen::HAL::BGCNT_COLOR_MODE | (31 << GBA::Screen::HAL::BGCNT_TILEMAP)
    GBA::Screen::HAL.dispcnt = GBA::Screen::HAL::DISPCNT_MODE_0 | GBA::Screen::HAL::DISPCNT_BACKGROUND_0

    #GBA::Screen::Mode3.init
  end

  def call
    @@i = @@i &+ 1
  end

  def draw
    # set ONE tile in the current drawn tilemap
    # ((pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 31).as(UInt16*) + (@@i >> 3)).value = (@@i >> 3).to_u16!
    ((pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 31).as(UInt32*) + (@@i >> 3)).value = pointerof(Assets::Minimal.map_start)[@@i >> 3]
    # the most basic tilemap entry: index into the tilemap
    #GBA::Screen::Mode3[@@i] = 0x0ff0u16
  end
end
