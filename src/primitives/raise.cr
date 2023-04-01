require "../interrupts/hal"
require "../screen/hal"
require "../text"

def raise(error : String) : NoReturn
  GBA::Interrupts::HAL.ime = 0  
  GBA::Screen::HAL.bg0cnt = 31 << GBA::Screen::HAL::BGCNT_TILEMAP
  GBA::Screen::HAL.dispcnt = GBA::Screen::HAL::DISPCNT_MODE_0 | GBA::Screen::HAL::DISPCNT_BACKGROUND_0
  GBA::Screen::HAL.bg0hofs = 0u32
  GBA::Screen::HAL.bg0vofs = 0u32
  Text.display 31, x: 0, y: 0, width: 30, height: 20, str: error 
  while true
  end
end
