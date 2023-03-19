require "./primitives"
require "./screen/hal"
require "./screen/mode_3"
require "./screen/mode_4"
require "./keypad/hal"
require "./interrupts/hal"

# Instead of using the crystal `main` calling the `__crystal_main` which contain the program (the top level),
# We use our own main called manually in the startup code.
# This way we can completely ignore the startup code initialized by crystal.
fun gba_main1 : NoReturn
  # Set a few pixels, then flip between mode 4 two pages every time button A is down.
  # Note: in MGBA, default keyboard binding for button A is 'x'.

  GBA::Screen::Mode3.init
  GBA::Screen::HAL.vram.access_16b[10 &* 240 &+ 10] = 0x00ffu16

  GBA::Screen::Mode3.init
  GBA::Screen::Mode3[0, 0] = 0xffffu16
  GBA::Screen::Mode3[1, 0] = 0xffffu16
  GBA::Screen::HAL.palette.backgrounds[0xff] = 0b11111
  GBA::Screen::HAL.palette.backgrounds[0xaa] = 0b1111100000
  GBA::Screen::Mode4.init
  GBA::Screen::Mode4[1, 0] = 0xaau16
  GBA::Screen::Mode4[2, 0] = 0xaau16
  GBA::Screen::Mode4.flip
  GBA::Screen::Mode4[1, 0] = 0xaau16
  GBA::Screen::Mode4[2, 0] = 0xaau16

  GBA::Keypad::HAL.keycnt = GBA::Keypad::HAL::KEYCNT_ENABLE_IRQ | GBA::Keypad::HAL::KEY_A
  GBA::Interrupts::HAL.ie |= GBA::Interrupts::HAL::IRQ_KEYPAD
  GBA::Interrupts::HAL.handler = ->do
    GBA::Screen::Mode4.flip
    GBA::Interrupts::HAL.if = GBA::Interrupts::HAL::IRQ_KEYPAD
  end
  GBA::Interrupts::HAL.ime = 1
  
  while true
  end
end

module State
  extend self
  @@off_in_map_x = 0
  def self.off_in_map_x
    @@off_in_map_x
  end
  @@off_in_map_y = 0
  def self.off_in_map_y
    @@off_in_map_y
  end
end

# Testing if we can, during a single HBLANK, set a full GBA screen region of a tilemaps.
fun gba_main()
  # set four colors:
  GBA::Screen::HAL.palette.backgrounds[1] = 0b0111110000000000u16
  GBA::Screen::HAL.palette.backgrounds[2] = 0b0000001111100000u16

  # Create a 8bpp tileset of two alternating colors tiles:
  # aka 8*8*1 byte (64 byte, or 16 word)
  i = 0
  while i < 16
    (pointerof(GBA::Screen::HAL.vram).as(UInt32*) + i + 16).value = 0x01010101u32
    (pointerof(GBA::Screen::HAL.vram).as(UInt32*) + i + 32).value = 0x02020202u32
    i &+= 1
  end

  # Now create a tilemaps, fully set to a reference to the first tile.
  # A tileset usually take same space as 8 tilemaps but ours is not full and very small.
  # A tilemap is 32 * 32 entries, each 16bpp. In its simplest form, it is just an index into a tileset:
  i = 0
  while i < 512
    ((pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 8).as(UInt32*) + i).value = 0x00010001u32
    i &+= 1
  end
  
  i = 0
  while i < 512
    ((pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 9).as(UInt32*) + i).value = 0x00020002u32
    i &+= 1
  end
  
  # Configure the background 0 to use out tileset (0 so nothing to do), tilemap (1), in 8bpp:
  GBA::Screen::HAL.bg0cnt = GBA::Screen::HAL::BGCNT_COLOR_MODE | (8 << GBA::Screen::HAL::BGCNT_TILEMAP)
  # Enable tiled mode with BG0 enabled
  GBA::Screen::HAL.dispcnt = GBA::Screen::HAL::DISPCNT_MODE_0 | GBA::Screen::HAL::DISPCNT_BACKGROUND_0

  # This should be enough yo display our screen full of the color 1.
  # while true
  # end
  
  # Enable VBLANK interrupts:
  GBA::Screen::HAL.dispstat = GBA::Screen::HAL::DISPTAT_VBLANK_INTERRUPT
  GBA::Interrupts::HAL.ie |= GBA::Interrupts::HAL::IRQ_VBLANK
  # Handler for interrupts:
  GBA::Interrupts::HAL.handler = ->do
    # Tile offset within the backgrounds 
    bx = State.off_in_map_x
    by = State.off_in_map_y
   
     y = 0
    while y < {{160 // 8 + 1}}
      x = 0
      while x < {{240 // 8 + 1}}
        # << is *32, the width in tile of a tilemap.
        # BTW here we assume we have a 1 tilemap sized background. If more, the calculation are a little more complex,
        # each coordinate must be adjusted to the right tilemap
        output_index = y &* 32 &+ x
        input_index = ((by &+ y) << 5) &+ bx &+ x
        ((pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 8).as(UInt16*) + output_index).value =
          ((pointerof(GBA::Screen::HAL.vram).as(GBA::Screen::HAL::Tilemap*) + 9).as(UInt16*) + input_index).value
        x &+= 1
      end
      y &+= 1
    end

    # We never get out of the interrupt:
    while true
    end
    # If there is tearing on screen, it mean we failed to fill the screen
    GBA::Interrupts::HAL.if = GBA::Interrupts::HAL::IRQ_VBLANK
  end
  GBA::Interrupts::HAL.ime = 1
  while true
  end
end
