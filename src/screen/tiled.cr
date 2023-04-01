require "./hal"

module GBA::Screen
  extend self

  macro declare_palette(name)
    module Palettes
    lib {{name.id.camelcase}}
      $start = _binary_build_{{name.id.downcase}}_pal_bin_start : UInt32
      $size = _binary_build_{{name.id.downcase}}_pal_bin_size : UInt32
    end
    end
    @@pal_{{name}} : {UInt32*, UInt32} = {
      pointerof(Palettes::{{name.id.camelcase}}.start),
      pointerof(Palettes::{{name.id.camelcase}}.size).address.to_u32!
    }
  end

  macro declare_font(name)
    module Fonts
    lib {{name.id.camelcase}}
      $start = _binary_assets_{{name.id.downcase}}_font_bin_start : UInt32
      $size = _binary_assets_{{name.id.downcase}}_font_bin_size : UInt32
    end
    end
    @@font_{{name}} : {UInt32*, UInt32} = {
      pointerof(Fonts::{{name.id.camelcase}}.start),
      pointerof(Fonts::{{name.id.camelcase}}.size).address.to_u32!
    }
  end
    
  def copy_palette(data, size, to palette_index)
    i = 0
    pal = pointerof(HAL.palette).as(UInt32*) + (palette_index << 2) # * 4
    while i < (size >> 2)
      pal[i] = data[i]
      i &+= 1
    end
  end

  def copy_bitpacked_font(data, size, index, offset, background, foreground)
    dest = pointerof(HAL.vram).as(UInt32*) + (index &* 0x1000) + (8 &* offset)
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
  
  # Extract the given bitpacked font. Assume 4 bpp mode.
  def copy_bitpacked_font2(data, size, index, offset, background, foreground)
    i = 0
    j = 0
    p = 0
    # 0x4000 is the size of a full tileset, / 4 bcz we use u32.
    # Could 'optimize' this with bitshift
    # 8*8 / 2 = 32 is the size of a tile, still / 4 = 8
    dest = pointerof(HAL.vram).as(UInt32*) + (index &* 0x1000) + (8 &* offset)
    bg_shift = background << 4
    fg_shift = foreground << 4
    while i < (size >> 2)
      # for each char which are two u32 wide, we fill one tile (8u32)
      j = 0b10000000_00000000_00000000_00000000
      while j != 0
        k = 0
        px = 0u32
        while k < 32
          px |= ((
            (data[i] & j) != 0 ? fg_shift : bg_shift
          ) | (
            (data[i] & (j >> 1))? background : foreground
          )) << k
          k &+= 8
          j = j >> 2
        end
        data[i] = px
        p &+= 1
      end
      i &+= 1
    end
  end
end
