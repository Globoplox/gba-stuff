module GBA::Screen
  lib HAL
    DISPCNT_MODE_3 = 0b011u16
    DISPCNT_MODE_4 = 0b100u16
    DISPCNT_MODE_5 = 0b101u16
    DISPCNT_BACKGROUND_2 = {{1u16 << 0xA}}
    DISPCNT_PAGE_SELECT = {{1u16 << 4}}
    
    union Vram
      access_16b : UInt16[48000]
      access_32b : UInt32[24000]
    end

    struct Palette
      backgrounds : UInt16[256]
      sprites : UInt16[256]
    end
    
    $vram = VRAM : Vram
    $palette = PALETTE : Palette
    $dispcnt = DISPCNT : UInt16
  end
end
