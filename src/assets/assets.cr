module Assets
  extend self

  abstract struct Asset
    @before : Indexable(Asset*)?
    def initialize(@before)
    end
    
    def load 
      @before.try(&.each(&.value.load))
    end

    def free 
      @before.try &.each &.value.free
    end
  end

  struct Group < Asset
  end

  struct Tileset < Asset
    
    @loaded_at : UInt8?
    @size : UInt32
    @data : UInt32*

    def loaded_at
      @loaded_at
    end

    def size
      @size
    end

    def data
      @data
    end

    def loaded_at=(i)
      @loaded_at = i
    end

    def initialize(@before, @size, @data)
    end

    def load
      super.load
      a = self
      Loader.load_tileset pointerof(a)
    end
    
    def free
      super.free
      a = self
      Loader.free_tileset pointerof(a)
    end
  end


  struct Palette < Asset
    
    @loaded_at : UInt8?
    @size : UInt32
    @data : UInt32*

    def loaded_at
      @loaded_at
    end

    def size
      @size
    end

    def data
      @data
    end

    def loaded_at=(i)
      @loaded_at = i
    end

    def initialize(@before, @size, @data)
    end

    def load
      super
      a = self
      Loader.load_palette pointerof(a)
    end
    
    def free
      super
      a = self
      Loader.free_palette pointerof(a)
    end
  end
    
  module Loader
    extend self

    PALETTES_SLOTS = StaticArray(UInt32, 16).new

    def load_tileset(tileset : Tileset*)
    end

    def free_tileset(tileset : Tileset*)
    end

    def load_palette(palette : Palette*)
      if !palette.value.loaded_at
        i = 0u8
        while i < 16
          if PALETTES_SLOTS[i] == 0
            PALETTES_SLOTS[i] = palette.address.to_u32!
            palette.value.loaded_at = i
            j = 0
            pal = pointerof(Screen::HAL.palette).as(UInt16*) + (i << 4)
            while j < (palette.value.size >> 1)
              pal[j] = palette.value.data.as(UInt16*)[j]
              j &+= 1
            end
            return
          end
          i &+= 1
        end
        raise "Cannot load palette"
      end
    end

    def free_palette(palette : Palette*)
      if i = palette.value.loaded_at
        PALETTES_SLOTS[i] = Pointer(Palette).null
        palette.value.loaded_at = nil
      end
    end
  end  
end
