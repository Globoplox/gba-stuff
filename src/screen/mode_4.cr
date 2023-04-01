require "./hal"

module Screen::Mode4
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
  
