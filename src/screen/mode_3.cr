require "./hal"

module Screen::Mode3
  extend self
  
  def init
    HAL.dispcnt = HAL::DISPCNT_MODE_3 | HAL::DISPCNT_BACKGROUND_2
  end
  
  WIDTH = 240
  HEIGHT = 160
  
  def []=(x, y, color : UInt16)
    HAL.vram.access_16b[y &* WIDTH &+ x] = color
  end

  def []=(i, color : UInt16)
    HAL.vram.access_16b[i] = color
  end
end
