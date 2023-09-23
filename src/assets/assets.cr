module Assets
  extend self

  abstract struct Asset
    abstract def load
    abstract def free

    @before : Indexable(Asset*)?
    
    def initialize(@before)
    end
  end

  struct Group < Asset
    def load
      pointerof(Screen::HAL.palette).as(UInt16*)[0xf] = 0x700fu16
      pointerof(Screen::HAL.palette).as(UInt16*)[0xe] = @before.try(&.size.to_u16!) || 0x700fu16 
      
      # Both display the same value, aka, @before.try(&.[0]) == Assets::BasePalette
      pointerof(Screen::HAL.palette).as(UInt32*)[0x3] = @before.try(&.[0].address.to_u32!) || 0x700fu32 
      pointerof(Screen::HAL.palette).as(UInt32*)[0x4] = pointerof(Assets::BasePalette).address.to_u32! 
      
      # Do work
      #Assets::BasePalette.load
      # Do not works
      #@before.try(&.[0].value.load)
      # Works
      @before.try(&.[0].as(Palette*).value.load)
      # : (

      @before.try &.each &.value.load
    end

    def free
      @before.try &.each &.value.free
    end
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
      @before.try &.each &.value.load 
      a = self
      Loader.load_tileset pointerof(a)
    end
    
    def free
      @before.try &.each &.value.free
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
      @before.try &.each &.value.load 
      a = self
      Loader.load_palette pointerof(a)
    end
    
    def free
      @before.try &.each &.value.free
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
