module GBA
  lib Screen
    WIDTH = 240
    HEIGHT = 160
    DISPCNT_MODE_3 = 0b011u16
    DISPCNT_BACKGROUND_2 = {{1u16 << 0xA}}
    
    $vram = VRAM : UInt16[HEIGHT][WIDTH] 
    $dispcnt = DISPCNT : UInt16
  end
end

struct StaticArray(T, N)
  def [](index)
    (pointerof(@buffer) + index).value
  end

  def []=(index, value)
    (pointerof(@buffer) + index).value = value
  end
end

GBA::Screen.vram[0][0] = 0xffffu16
GBA::Screen.dispcnt = GBA::Screen::DISPCNT_MODE_3 | GBA::Screen::DISPCNT_BACKGROUND_2
while true
end

###############

# module GBA
#   lib Screen
#     WIDTH = 240
#     HEIGHT = 160
#     DISPCNT_MODE_3 = 0b011u16
#     DISPCNT_BACKGROUND_2 = {{1u16 << 0xA}}
    
#     $vram = VRAM : UInt16
#     $dispcnt = DISPCNT : UInt16
#   end
# end

# GBA::Screen.vram = 0xffffu16
# GBA::Screen.dispcnt = GBA::Screen::DISPCNT_MODE_3 | GBA::Screen::DISPCNT_BACKGROUND_2
# while true
# end
