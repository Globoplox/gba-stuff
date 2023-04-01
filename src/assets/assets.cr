require "../screen/hal"

module GBA::Assets
  extend self

  macro declare_palette(name)
    module Palettes
    lib {{name.id.camelcase}}
      $start = _binary_build_{{name.id.downcase}}_pal_bin_start : UInt32
      $size = _binary_build_{{name.id.downcase}}_pal_bin_size : UInt32
    end
    end
    # @@pal_{{name}} : {UInt32*, UInt32} = {
    #   pointerof(Palettes::{{name.id.camelcase}}.start),
    #   pointerof(Palettes::{{name.id.camelcase}}.size).address.to_u32!
    # }
  end

  macro declare_font(name)
    module Fonts
    lib {{name.id.camelcase}}
      $start = _binary_assets_{{name.id.downcase}}_font_bin_start : UInt32
      $size = _binary_assets_{{name.id.downcase}}_font_bin_size : UInt32
    end
    end
    # @@font_{{name}} : {UInt32*, UInt32} = {
    #   pointerof(Fonts::{{name.id.camelcase}}.start),
    #   pointerof(Fonts::{{name.id.camelcase}}.size).address.to_u32!
    # }
  end
    
  def copy_palette(data, size, to palette_index)
    i = 0
    pal = pointerof(Screen::HAL.palette).as(UInt32*) + (palette_index << 2) # * 4
    while i < (size >> 2)
      pal[i] = data[i]
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
