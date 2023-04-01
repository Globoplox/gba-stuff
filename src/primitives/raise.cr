require "../interrupts/hal"
require "../screen/hal"

# Assume the base palette and tileset has been loaded.
def raise(error : String) : NoReturn
  GBA::Interrupts::HAL.ime = 0
  
  GBA::Screen::HAL.bg0cnt = 31 << GBA::Screen::HAL::BGCNT_TILEMAP
  GBA::Screen::HAL.dispcnt = GBA::Screen::HAL::DISPCNT_MODE_0 | GBA::Screen::HAL::DISPCNT_BACKGROUND_0
  GBA::Screen::HAL.bg0hofs = 0u32
  GBA::Screen::HAL.bg0vofs = 0u32
  base = (pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 31).as(UInt16*)
  x = 0
  y = 0
  i = 0
  size = error.bytesize
  error = error.to_unsafe
  while i < size
    c = error[i]
    if c >= 0x20 & c < 0x80
      base[y &* 32 &+ x] = c &- 0x1d
      x &+= 1
      if x >= 30
        x = 0
        y &+= 1
        while true
        end if y >= 20
      end
    end
    i &+= 1
  end
  while true
  end
end
