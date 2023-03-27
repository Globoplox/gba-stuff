require "./hal"

module GBA::Screen
  extend self

  macro declare_palette(name)
    lib {{name.id.camelcase}}
      $start = _binary_build_{{name.id.downcase}}_pal_bin_start : UInt32
      $size = _binary_build_{{name.id.downcase}}_pal_bin_size : UInt32
    end
    @@{{name}} : {UInt32*, UInt32} = {
      pointerof({{name.id.camelcase}}.start),
      pointerof({{name.id.camelcase}}.size).address.to_u32!
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
end
