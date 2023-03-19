module GBA::Screen

  # The GBA graphic system is quite cool.
  # It has a 160*240 screen. It handle 16bpp colors. 
  # The hardware is constantly redrawing the screen at an approximate rate of 60fps.
  # At each frame, it:
  # - Draw a 240 pixel line
  # - Do nothing for a few cycles (HBLANK)
  # - Repeat for each 160 lines
  # - Do nothing for a longer time (VBLANK)
  # To determine the color of each pixels, it read in the video memory (vram), the palette ram (pal) and the sprites memory (oam).
  # The way the vram is interpreted depends on a number of settings controlled by registers. 
  # The most important setting being the modes: bitmap modes and tiled modes.
  # In  tile modes, the screen is a superposition of up to four backgrounds, each being
  # composed of up to 64 per 64 tiles of 8 pixels each.
  # In these modes, the video memory is split between tilesets, defining the pixel data of each tiles,
  # and tilemaps, defining the tiles to use to compose a backgrounds.
  # Color are 16bpp. Most of the time, the color are stored in the 512 color palette and the vram only reference index in the palette.
  lib HAL
    # The flags for setting `dispcnt`, the main screen control register: 
    # Tiled modes
    DISPCNT_MODE_0 = 0b000u16 # Allows use of all four backgrounds as regular backgrounds.
    DISPCNT_MODE_1 = 0b001u16 # Allows use of bg 0 and 1 as reguar, bg 2 as affine.
    DISPCNT_MODE_2 = 0b010u16 # Allows use of bg 2 and bg 3 as affine.

    # Bitmap modes
    DISPCNT_MODE_3 = 0b011u16
    DISPCNT_MODE_4 = 0b100u16
    DISPCNT_MODE_5 = 0b101u16
    # There is a mode 7 but it is kind of special.

    # Read-only bit, set if running in game-boy-color mode.
    DISPCNT_IS_GBC = {{1 << 0x3}}
    # For mode 4 & 5, set / clear to flip the page being drawn.
    DISPCNT_PAGE_SELECT = {{1 << 0x4}}

    # Allows to access OAM memory (sprites) during HBLANK.
    # HBLANK happens periodically when the GBA hardawre
    # has finished drawing a line.
    DISPCNT_ACCESS_OAM = {{1 << 0x5}}

    # Object (sprites) mapping mode (1d or 2d indexing). 
    DISPCNT_MAPPING_MODE = {{1 << 0x6}}

    # Set to force blanck screen.
    DISPCNT_BLANK = {{1 << 0x7}}

    # Enable rendering of the backgrounds in tiled mode.
    # A background is a combination of a tilemap and a tileset.
    # Background 2 must be enabled in bitmap modes.
    DISPCNT_BACKGROUND_0 = {{1 << 0x8}}
    DISPCNT_BACKGROUND_1 = {{1 << 0x9}}
    DISPCNT_BACKGROUND_2 = {{1 << 0xA}}
    DISPCNT_BACKGROUND_3 = {{1 << 0xB}}

    # Enable rendering of objects (sprites).
    DISPCNT_OBJECT = {{1 <<  0xC}}

    # Enable rendering of 'windows'.
    DISPCNT_WINDOW_0 = {{1 << 0xD}}
    DISPCNT_WINDOW_1 = {{1 << 0xE}}
    DISPCNT_WINDOW_OBJECT = {{1 << 0xF}}

    # In tiled modes    
    # A tileset is a collection of tiles, 8 per 8 pixels per tiles.
    # A tileset can be either:
    # - 512 tiles of 8 * 8 pixels, each 4 bits
    #   (they are an offset in a 16 entry sub-palette, which itself is selected by a setting in the entries of a tilemaps)
    # - 256 tiles of 8 * 8 pixels, each 8 bits
    #   (an offset in the full background palette)
    # The mode is selected independently for each background.
    # NOTE: accessing vram can be only in 16 or 32 bits. There is no 8 bits (and certainly no 4 bits access)
    #       and trying to will cause strangeness.
    union Tileset
      access_16b : UInt16[8192]
      access_32b : UInt32[4096]
    end

    # In tiled modes
    # A tile map is a 32*32 matrix of references to tiles in tileset.
    # Each entry is 16b. See corresponding macro flags for the format. 
    union Tilemap
      access_16b : UInt16[1024]
      access_32b : UInt32[512]
    end

    # The ten first bits are a number between 0 and 1024. As a tilemap has only up to 512 tiles that mean you can
    # references tile in the next tilemap too. 
    TILEMAP_TILE_INDEX_FILTER = 0b1111111111u16
    # If set the tile is displayed horizontally flipped.
    TILEMAP_HORIZONTAL_FLIP = {{1 << 0xA}}
    # If set the tile is displayed vertically flipped.
    TILEMAP_VERTICAL_FLIP = {{1 << 0xB}}
    # If the background is in 4bbp mode, then this select the subpalette the 4 bits of each tile are an index of.
    # If the background is in 8bpp, this is unused.
    TILEMAP_PALETTE_INDEX_INDEX = 0xC

    # Macro for configuring backgrounds.
    # Drawing order of backgrounds.
    BGCNT_PRIORITY = 0x0
    # Which of the four possible tileset to use.
    BGCNT_TILESET = 0x2
    # Enable mosaic mode.
    BGCNT_MOSAIC = {{1 << 0x6}}
    # If clear, tileset is interpreted as 512 tiles, 8 * 8 pixels, 4 bpp
    #  (index in subpalette selected by each entries of a tilemap that reference this tile). 
    # If set, tileset is interpreted as 256 tiles, 8 * 8 pixels, 8 bpp idndex in the palette.
    BGCNT_COLOR_MODE = {{1 << 0x7}}
    # Select which of the 32 possible tilemap to use (or to start at, as backgrounds can use up to 4 consecutive tilemaps). 
    BGCNT_TILEMAP = 0x8u16
    # Unused for regular backgrounds.
    BGCNT_WRAP = 0xDu16
    # Select the layout of the tilemaps composing the backgrounds:
    #
    # 0: +-+  1: +-+-+  2: +-+  3: +-+-+  
    #    |0|     |0|1|     |0|     |0|1|
    #    +-+     +-+-+     +-+     +-+-+
    #                      |1|     |2|3|
    #                      +-+     +-+-+
    #
    BGCNT_SIZE = 0xEu16    
    
    # Video ram layout varies greatly between modes.
    # This union helps accessing it in diffents ways.
    union Vram
      access_16b : UInt16[48000]
      access_32b : UInt32[24000]
      tilesets : Tileset[4]
      tilemaps : Tilemap[32] 
    end

    struct Palette
      backgrounds : UInt16[256]
      sprites : UInt16[256]
    end

    # Video memory location. It's layout depends on the mode.
    $vram = VRAM : Vram

    # Color palette memory location. Again there are different modes.
    $palette = PALETTE : Palette

    # Register from controlling video modes and parameters. 
    $dispcnt = DISPCNT : UInt16

    # Registers controlling the offsets of the region of a background to display:
    # NOTE: they are WRITE-ONLY. You can't read them.
    # Horizontal:
    $bg0hofs = BG0HOFS : UInt16
    $bg1hofs = BG1HOFS : UInt16
    $bg2hofs = BG2HOFS : UInt16
    $bg3hofs = BG3HOFS : UInt16
    # Vertical
    $bg0vofs = BG0VOFS : UInt16
    $bg1vofs = BG1VOFS : UInt16
    $bg2vofs = BG2VOFS : UInt16
    $bg3vofs = BG3VOFS : UInt16

    # Backgrounds control registers:
    $bg0cnt = BG0CNT : UInt16
    $bg1cnt = BG1CNT : UInt16
    $bg2cnt = BG2CNT : UInt16
    $bg3cnt = BG3CNT : UInt16

    # Read only register, the current line being drawn.
    $vcount = VCOUNT : UInt16

    # Is set, we are currently in a VBLANK.
    DISPTAT_IN_VBLANK =  {{1 << 0}}
    # Is set, we are currently in a HBLANK.
    DISPTAT_IN_HBLANK = {{1 << 1}}
    # Is set, we are at the scan line indicated in DISPSTAT_VCT.
    DISPTAT_IN_VCT = {{1 << 2}}
    # Is set, enable firing interrupt when entering a VBLANK.
    DISPTAT_VBLANK_INTERRUPT = {{1 << 3}}
    # Is set, enable firing interrupt when entering a HBLANK.
    DISPTAT_HBLANK_INTERRUPT = {{1 << 4}}
    # Is set, enable firing interrupt when entering the DISPSTAT_VCT line.
    DISPTAT_VCT_INTERRUPT = {{1 << 5}}
    # Set the VCT index, a scan line of special interest to use with other flags of DISPSTAT. 
    DISPTAT_VCT_INDEX = 8

    # Register to read display status and toggle firing of interrupts at key timings.
    $dispstat = DISPSTAT : UInt16
  end
end
