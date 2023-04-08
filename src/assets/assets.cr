require "../screen/hal"

module Assets
  extend self

  macro declare_palette(name)
    module Palettes
      lib {{name.id.camelcase}}
        $start = _binary___build_palette_{{name.id.downcase}}_bin_start : UInt32
        $size = _binary___build_palette_{{name.id.downcase}}_bin_size : UInt32
      end
    end
  end

  macro declare_tileset(name)
    module Tilesets
      lib {{name.id.camelcase}}
        $start = _binary___build_tileset_{{name.id.downcase}}_bin_start : UInt32
        $size = _binary___build_tileset_{{name.id.downcase}}_bin_size : UInt32
      end
    end
  end
    
  def copy_palette(data, size, index, offset)
    i = 0
    pal = pointerof(Screen::HAL.palette).as(UInt16*) + (index << 3) + offset # * 4
    while i < (size >> 1)
      pal[i] = data.as(UInt16*)[i]
      i &+= 1
    end
  end

  def copy_tileset(data, size, index, offset)
    dest = pointerof(Screen::HAL.vram).as(UInt32*) + (index &* 0x1000) + (8 &* offset)
    i = 0 
    while i < (size >> 2)
      dest[i] = data[i]
      i &+= 1
    end
  end

  def copy_bitpacked_font(data, size, index, offset, background, foreground)
    dest = pointerof(Screen::HAL.vram).as(UInt32*) + (index &* 0x1000) + (8 &* offset)
    # for each bit in data, write 4bit in dest.
    # Let's not forget memory is accessed by 16 or 32 b only 
    i = 0u32
    size = size >> 2
    while i < size
      v = data[i]
      b = 0u32
      buffer = 0u32
      while b < 32u32
        if v & (1 << b) != 0
          buffer |= foreground
        else
          buffer |= background
        end        
        b &+= 1
        if b == 8 || b == 16 || b == 24 || b == 32
          dest[i &* 4 &+ (b >> 3) &- 1] = buffer
          buffer = 0u32
        else
          buffer = buffer << 4
        end
      end
      i &+= 1
    end
  end
  
end
