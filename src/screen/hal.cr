module GBA::Screen
  lib HAL
    # The flags for setting `dispcnt`: 

    # Tiled modes
    DISPCNT_MODE_0 = 0b011u16 # Allows use of all four backgrounds as regular backgrounds.
    DISPCNT_MODE_1 = 0b100u16 # Allows use of bg 0 and 1 as reguar, bg 2 as affine.
    DISPCNT_MODE_2 = 0b101u16 # Allows use of bg 2 and bg 3 as affine.

    # Bitmap modes
    DISPCNT_MODE_3 = 0b011u16
    DISPCNT_MODE_4 = 0b100u16
    DISPCNT_MODE_5 = 0b101u16
    # There is a mode 7 but it is kind of special.

    # Read-only bit, set if running in game-boy-color mode.
    DISPCNT_IS_GBC = {{1 <<  0x3}}
    # For mode 4 & 5, set / clear to flip the page being drawn.
    DISPCNT_PAGE_SELECT = {{1 <<  0x4}}

    # Allows to access OAM memory (sprites) during HBLANK.
    # HBLANK happens periodically when the GBA hardawre
    # has finished drawing a line.
    DISPCNT_ACCESS_OAM = {{1 <<  0x5}}

    # Object (sprites) mapping mode (1d or 2d indexing). 
    DISPCNT_MAPPING_MODE = {{1 << 0x6}}

    # Set to force blanck screen
    DISPCNT_BLANK = {{1 <<  0x7}}

    # Enable rendering of the backgrounds in tiled mode.
    # A background is a combination of a tilemap and a tileset.
    # Background 2 must be enabled in bitmap modes.
    DISPCNT_BACKGROUND_0 = {{1 <<  0x8}}
    DISPCNT_BACKGROUND_1 = {{1 <<  0x9}}
    DISPCNT_BACKGROUND_2 = {{1 <<  0xA}}
    DISPCNT_BACKGROUND_3 = {{1 <<  0xB}}

    # Enable rendering of objects (sprites).
    DISPCNT_OBJECT = {{1 <<  0xC}}

    # Enable rendering of 'windows'.
    DISPCNT_WINDOW_0 = {{1 <<  0xD}}
    DISPCNT_WINDOW_1 = {{1 <<  0xE}}
    DISPCNT_WINDOW_OBJECT = {{1 << 0xF}}

    # In tiled modes
    
    # # A tileset is a collection of tiles, 8 per 8 pixels per tiles.
    # # A tileset can be either:
    # # - 512 tiles of 8 * 8 pixels, each 4 bits
    # #   (they are an offset in a 16 entry sub-palette, which itself is selected by a setting in the entries of a tilemaps)
    # # - 245 tiles of 8 * 8 pixels, each 8 bits
    # #   (an offset in the full background palette)
    # # NOTE: accessing vram can be only in 16 or 32 bits. There is no 8 bits (and certainly no 4 bits access)
    # #       and trying to will cause strangeness.
    # union Tileset
    # end

    
    
    # Video ram layout varies greatly between modes.
    # This union helps accessing it in diffents ways.
    union Vram
      access_16b : UInt16[48000]
      access_32b : UInt32[24000]
      #tilesets : Tileset[4]
      #tilemaps : Tilemaps[32] 
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
  end
end
