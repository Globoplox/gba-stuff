module Assets
  extend self

  module Loader
    extend self

    PALETTES_SLOTS = StaticArray(UInt32, 16).new

    def load_tileset(tileset)
    end

    def free_tileset(tileset)
    end

    def load_palette(palette)
      if palette.loaded_at
        palette.ref_count += 1
      else
        i = 0u8
        while i < 16
          if PALETTES_SLOTS[i] == 0
            PALETTES_SLOTS[i] = pointerof(palette).address.to_u32!
            palette.loaded_at = i
            j = 0
            pal = pointerof(Screen::HAL.palette).as(UInt16*) + (i << 4)
            while j < (palette.size >> 1)
              pal[j] = palette.data.as(UInt16*)[j]
              j &+= 1
            end
            return
          end
          i &+= 1
        end
        raise "Cannot load palette"
      end
    end

    def free_palette(palette)
      if i = palette.loaded_at
        palette.ref_count -= 1
        if palette.ref_count == 0
          PALETTES_SLOTS[i] = 0
          palette.value.loaded_at = nil
        end
      end
    end
  end  
end
