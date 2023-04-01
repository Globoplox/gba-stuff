require "../state"
require "../screen/tiled"

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

# having mutliple tileset at the same time mean having a single palette.
# Maybe we can reserve slot for palette.
# In battle map mode, something like: 4 our of 16 palette for the tiles, 1 for effects, 1 or two for menus, .... 

module Splash
  extend self
  include State

  GBA::Screen.declare_palette base
  GBA::Screen.declare_font base
  
  def draw_init
    
    # Copy the first palette 'base'
    # to subpalette 0

    # Does not works because of missing crystal main and @@ init.
    # Maybe this was not worth it.
    
    #GBA::Screen.copy_palette *@@base, to: 0

    GBA::Screen.copy_palette(
      pointerof(Palettes::Base.start).as(UInt32*),
      pointerof(Palettes::Base.size).address.to_u32!,
      to: 0
    )

    GBA::Screen.copy_bitpacked_font(
      pointerof(Fonts::Base.start).as(UInt32*),
      pointerof(Fonts::Base.size).address.to_u32!,
      index: 0u32, offset: 0x3u32, background: 0x1u32, foreground: 0x2u32
    )

    # Copy the splash screen.
        
    GBA::Screen::HAL.bg0cnt = GBA::Screen::HAL::BGCNT_COLOR_MODE | (31 << GBA::Screen::HAL::BGCNT_TILEMAP)
    GBA::Screen::HAL.dispcnt = GBA::Screen::HAL::DISPCNT_MODE_0 | GBA::Screen::HAL::DISPCNT_BACKGROUND_0

    raise "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  end

  def call
  end

  def draw
  end
end
