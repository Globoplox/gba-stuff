require "../state"
require "../text"

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
  @@i = 0
  
  def draw_init
    Screen::HAL.bg0cnt = 31 << Screen::HAL::BGCNT_TILEMAP
    Screen::HAL.dispcnt = Screen::HAL::DISPCNT_MODE_0 | Screen::HAL::DISPCNT_BACKGROUND_0
    # load background,
    # setup a sprite/animation ?
  end

  def call
    @@i &+= 1 if Keypad.a.pressed?
  end

  def draw
    if @@i > 16
      raise "Finished"
    else
      Text.display 31, "Splash screen", width: @@i, height: 1
    end
  end
end
