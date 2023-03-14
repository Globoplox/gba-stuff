struct StaticArray(T, N)
  def []=(index, value : T)
    (pointerof(@buffer) + index).value = value
  end

  def [](index) : T
    (pointerof(@buffer) + index).value
  end
end

struct Int
  def <<(other)
    unsafe_shl other
  end

  def >>(other)
    unsafe_shr other
  end

  # TODO does not work. I can do div in C, what is different here ?
  def //(other)
    unsafe_div other
  end
end

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

  module Mode3
    extend self
    
    def init
      HAL.dispcnt = HAL::DISPCNT_MODE_3 | HAL::DISPCNT_BACKGROUND_2
    end

    WIDTH = 240
    HEIGHT = 160

    def []=(x, y, color : UInt16)
      HAL.vram.access_16b[y &* WIDTH &+ x] = color
    end
  end

  module Mode4
    extend self
    SECOND_PAGE_OFFSET = 0xa000u32
    @@page_offset = 0u32
    
    def init
      HAL.dispcnt = HAL::DISPCNT_MODE_4 | HAL::DISPCNT_BACKGROUND_2    
    end

    WIDTH = 240
    HEIGHT = 160

    def flip
      HAL.dispcnt ^= HAL::DISPCNT_PAGE_SELECT
      @@page_offset ^= SECOND_PAGE_OFFSET
    end

    def []=(x, y, palette_index : UInt8)
      i = (@@page_offset &+ y &* WIDTH  &+ x) >> 1
      px = HAL.vram.access_16b[i]
      if x & 1 == 0
       px = px & 0xff00 | palette_index.to_u16
      else
       px = px & 0x00ff | (palette_index.to_u16 << 0x8)
      end
      HAL.vram.access_16b[i] = px
    end
  end
  
end

# Instead of using the crystal `main` calling the `__crystal_main` which contain the program (the top level),
# We use our own main called manually in the startup code.
# This way we can completely ignore the startup code initialized by crystal.
fun gba_main 
  GBA::Screen::Mode3.init
  GBA::Screen::Mode3[0, 0] = 0xffffu16
  GBA::Screen::Mode3[1, 0] = 0xffffu16
  GBA::Screen::HAL.palette.backgrounds[0xff] = 0b11111
  GBA::Screen::HAL.palette.backgrounds[0xaa] = 0b1111100000
  GBA::Screen::Mode4.init
  GBA::Screen::Mode4[1, 0] = 0xaau16
  GBA::Screen::Mode4[2, 0] = 0xaau16
  GBA::Screen::Mode4.flip
  GBA::Screen::Mode4[1, 0] = 0xaau16
  GBA::Screen::Mode4[2, 0] = 0xaau16
  GBA::Screen::Mode4.flip

  while true
  end
end
