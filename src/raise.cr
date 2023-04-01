require "./interrupts"
require "./screen/hal"
require "./text"

def raise(error : String) : NoReturn
  Interrupts.ime = 0  
  Screen::HAL.bg0cnt = 31 << Screen::HAL::BGCNT_TILEMAP
  Screen::HAL.dispcnt = Screen::HAL::DISPCNT_MODE_0 | Screen::HAL::DISPCNT_BACKGROUND_0
  Screen::HAL.bg0hofs = 0u32
  Screen::HAL.bg0vofs = 0u32
  Text.display 31, x: 0, y: 0, width: 30, height: 20, str: error 
  while true
  end
end
