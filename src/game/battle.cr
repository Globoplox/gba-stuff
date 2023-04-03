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
#{ { `crystal ./src/compile_time/assets_links.cr minimal` }}
#{ { `crystal ./src/compile_time/assets_links.cr movement` }}

# having mutliple tileset at the same time mean having a single palette.
# Maybe we can reserve slot for palette.
# In battle map mode, something like: 4 our of 16 palette for the tiles, 1 for effects, 1 or two for menus, .... 

# Coordinate in megatile (a square of four normal 8px tiles).
# Map index is the 0...32 map to draw on.
# tile_base is the index where the movement tiles can be founds.
# previous is the direction (:left, :top, :bottom, :right) where of the origin of the direction.
# after is the same, but it can be nil.
# module Movement
#   TB_H = 0 # Horizontal lower half pipe
#   TB_V = 0 # Vertical left half pipe
#   def path(tile_base, map_index, x, y, previous, after)
#     map_base = (pointerof(Screen::HAL.vram).as(Screen::HAL::Tilemap*) + map_index).as(UInt16*)
#     case {previous, after}
#     when {:left, :right}, {:right,:left} then
#       map_base[y / 2 * 32 + x / 2] = (tile_base + TB_H) | Screen::HAL::TILEMAP_VERTICAL_FLIP
#       map_base[y / 2 * 32 + x / 2 + 1] =  (tile_base + TB_H) | Screen::HAL::TILEMAP_VERTICAL_FLIP
#       map_base[(y / 2 + 1) * 32 + x / 2] =  tile_base + TB_H
#       map_base[(y / 2 + 1) * 32 + x / 2 + 1] =  tile_base + TB_H
#     end
#   end
# end

# module Splash
#   extend self
#   include State
#   @@i = 0
  
#   def draw_init
        
#     # Both copy are inefficient, I know
#     # Copy the palette
#     c = 0
#     while c < pointerof(Assets::Minimal.pal_size).address.to_u32! >> 1
#       Screen::HAL.palette.backgrounds[c] = pointerof(Assets::Minimal.pal_start)[c]
#       c &+= 1
#     end

#     # Copy the tileset
#     t = 0
#     while t < pointerof(Assets::Minimal.set_size).address.to_u32! >> 2
#       Screen::HAL.vram.access_32b[t] =  pointerof(Assets::Minimal.set_start)[t]
#       t &+= 1
#     end
    
#     Screen::HAL.bg0cnt = Screen::HAL::BGCNT_COLOR_MODE | (31 << Screen::HAL::BGCNT_TILEMAP)
#     Screen::HAL.dispcnt = Screen::HAL::DISPCNT_MODE_0 | Screen::HAL::DISPCNT_BACKGROUND_0

#     #GBA::Screen::Mode3.init
#   end

#   def call
#     @@i = @@i &+ 1
#   end

#   def draw
#     # set ONE tile in the current drawn tilemap
#     # ((pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 31).as(UInt16*) + (@@i >> 3)).value = (@@i >> 3).to_u16!
#     ((pointerof(Screen::HAL.vram).as(Screen::HAL::Tilemap*) + 31).as(UInt32*) + (@@i >> 3)).value = pointerof(Assets::Minimal.map_start)[@@i >> 3]
#     # the most basic tilemap entry: index into the tilemap
#     #GBA::Screen::Mode3[@@i] = 0x0ff0u16
#   end
# end
