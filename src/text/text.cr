require "../screen/hal"

module Text
  extend self

  # TODO: x and Y cursor when the full text has not been displayed
  def display(map, str, x bx = 0, y by = 0, width = 32, height = 32)
    base = (pointerof(Screen::HAL.vram).as(Screen::HAL::Tilemap*) + 31).as(UInt16*)
    i = 0
    size = str.bytesize
    str = str.to_unsafe
    x = bx
    y = by
    maxx = bx &+ width
    maxy = by &+ height
    while i < size
      c = str[i]
      if c >= 0x20 & c < 0x80
        base[y &* 32 &+ x] = c &- 0x1d
        x &+= 1
        if x >= maxx
          x = bx
          y &+= 1
          return if y >= maxy
        end
      end
      i &+= 1
    end
  end  
end
