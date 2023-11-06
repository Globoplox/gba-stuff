module Assets
  extend self
  
  macro declare_group(name, *dependencies)
    module Assets::{{name.id.camelcase}}
      def self.load
        {% for dependency in dependencies %}
            {{dependency.id.camelcase}}.load
        {% end %}
      end
    end
  end

  macro declare_palette(name, *dependencies)
    module Assets::{{name.id.camelcase}}
      lib Symbols
        ${{name.id}}_start = _binary___build_asset_{{name.id}}_bin_start : UInt32
        ${{name.id}}_size = _binary___build_asset_{{name.id}}_bin_size : UInt32
      end
      @@loaded_at : UInt8?
      SIZE = pointerof(Symbols.{{name.id}}_size).address.to_u32!
      DATA = pointerof(Symbols.{{name.id}}_start)

      def self.loaded_at
        @@loaded_at
      end
      
      def self.loaded_at=(value)
        @@loaded_at = value
      end
      
      def self.size
        SIZE
      end

      def self.data
        DATA
      end
      
      def self.load
	      {% for dependency in dependencies %}
          {{dependency.id.camelcase}}.load
        {% end %}
        Loader.load_palette {{name.id.camelcase}}
      end
    end
  end

  module Loader
    extend self
    struct Entry
      @address : UInt32 = 0
      @ref_count : UInt8 = 0
    end

    PALETTES_SLOTS = StaticArray(Entry, 16).new

    def load_tileset(tileset)
    end

    def free_tileset(tileset)
    end

    def load_palette(palette)
      if loaded_at = palette.loaded_at
        PALETTES_SLOTS[loaded_at].@ref_count += 1
      else
        i = 0u8
        while i < 16
          if PALETTES_SLOTS[i].@address == 0
            PALETTES_SLOTS[i].@address = pointerof(palette).address.to_u32!
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
        palette.@ref_count -= 1
        if palette.@ref_count == 0
          PALETTES_SLOTS[i].@address = 0
          palette.value.loaded_at = nil
        end
      end
    end
  end  
end
