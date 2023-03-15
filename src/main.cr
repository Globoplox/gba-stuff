# Proc types seems to generate call to raise:
# https://crystal-lang.org/reference/1.7/syntax_and_semantics/c_bindings/callbacks.html
# > Note, however, that functions passed to C can't form closures. If the compiler detects at compile-time that a closure is being passed, an error will be issued.
# >  If the compiler can't detect this at compile-time, an exception will be raised at runtime.
# I don't know or to prevent it yet so lets juste define the symbol and leve it be for now.
def raise(__ignore : String): NoReturn
  while true
  end
end

struct StaticArray(T, N)
  def []=(index, value : T)
    (pointerof(@buffer) + index).value = value
  end

  def [](index) : T
    (pointerof(@buffer) + index).value
  end
end

struct Int
  def <<(other)
    unsafe_shl other
  end

  def >>(other)
    unsafe_shr other
  end

  # TODO does not work. I can do div in C, what is different here ?
  def //(other)
    unsafe_div other
  end
end

module GBA::Screen
  lib HAL
    DISPCNT_MODE_3 = 0b011u16
    DISPCNT_MODE_4 = 0b100u16
    DISPCNT_MODE_5 = 0b101u16
    DISPCNT_BACKGROUND_2 = {{1u16 << 0xA}}
    DISPCNT_PAGE_SELECT = {{1u16 << 4}}
    
    union Vram
      access_16b : UInt16[48000]
      access_32b : UInt32[24000]
    end

    struct Palette
      backgrounds : UInt16[256]
      sprites : UInt16[256]
    end
    
    $vram = VRAM : Vram
    $palette = PALETTE : Palette
    $dispcnt = DISPCNT : UInt16
  end

  module Mode3
    extend self
    
    def init
      HAL.dispcnt = HAL::DISPCNT_MODE_3 | HAL::DISPCNT_BACKGROUND_2
    end

    WIDTH = 240
    HEIGHT = 160

    def []=(x, y, color : UInt16)
      HAL.vram.access_16b[y &* WIDTH &+ x] = color
    end
  end

  module Mode4
    extend self
    SECOND_PAGE_OFFSET = 0xa000u32
    @@page_offset = 0u32
    
    def init
      HAL.dispcnt = HAL::DISPCNT_MODE_4 | HAL::DISPCNT_BACKGROUND_2    
    end

    WIDTH = 240
    HEIGHT = 160

    def flip
      HAL.dispcnt ^= HAL::DISPCNT_PAGE_SELECT
      @@page_offset ^= SECOND_PAGE_OFFSET
    end

    def []=(x, y, palette_index : UInt8)
      i = (@@page_offset &+ y &* WIDTH  &+ x) >> 1
      px = HAL.vram.access_16b[i]
      if x & 1 == 0
       px = px & 0xff00 | palette_index.to_u16
      else
       px = px & 0x00ff | (palette_index.to_u16 << 0x8)
      end
      HAL.vram.access_16b[i] = px
    end
  end
  
end

module GBA::Interrupts
  lib HAL
    IRQ_VBLANK = 1u16
    IRQ_HBLANK = {{1u16 << 1}}
    IRQ_VCOUNT = {{1u16 << 2}}
    IRQ_TIMER_0 = {{1u16 << 3}}
    IRQ_TIMER_1 = {{1u16 << 4}}
    IRQ_TIMER_2 = {{1u16 << 5}}
    IRQ_TIMER_3 = {{1u16 << 6}}
    IRQ_SERIAL_COM = {{1u16 << 7}}
    IRQ_DMA_0 = {{1u16 << 8}}
    IRQ_DMA_1 = {{1u16 << 9}}
    IRQ_DMA_2 = {{1u16 << 0xA}}
    IRQ_DMA_3 = {{1u16 << 0xB}}
    IRQ_KEYPAD = {{1u16 << 0xC}}
    IRQ_CART = {{1u16 << 0xD}}

    # IRQ Register I/O, set to enable the interrupts you need.
    $ie = IE : UInt16
    # IRQ Register I/O, set to acknowlege an interrupt has been handled.
    $if = IF : UInt16
    # IRQ master control I/O. Set to enable IRQ.
    $ime = IME : UInt16
    # The memory location where the BIOS/CPU expect to find the address of the IRQ Handler function.
    $handler = IRQ_HANDLER : -> Void
  end
end

module GBA::Keypad
  lib HAL
    KEY_A = 1
    KEY_B = {{1 << 1}}
    KEY_SELECT = {{1 << 2}}
    KEY_START = {{1 << 3}}
    KEY_RIGHT = {{1 << 4}}
    KEY_LEFT = {{1 << 5}}
    KEY_UP = {{1 << 6}}
    KEY_DOWN = {{1 << 7}}
    KEY_L = {{1 << 8}}
    KEY_R = {{1 << 9}}

    # Resgiter I/O for keypad input control.
    # Note the bit are set by default, and clear during input.
    $keyinput = KEYINPUT : UInt16
    
    KEYCNT_ENABLE_IRQ = {{1 << 0xE}}
    # If set, all enabled keys must be down to trigger irq. If clear, any enabled key down trigger the irq. 
    KEYCNT_MODE = {{1 << 0xF}}

    # Resgiter I/O for keypad interrupt control.
    $keycnt = KEYCNT : UInt16
  end
end

# Instead of using the crystal `main` calling the `__crystal_main` which contain the program (the top level),
# We use our own main called manually in the startup code.
# This way we can completely ignore the startup code initialized by crystal.
fun gba_main : NoReturn
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
  GBA::Interrupts::HAL.ime = 1
  GBA::Interrupts::HAL.handler = ->do
    GBA::Screen::Mode4.flip
    pointerof(GBA::Interrupts::HAL.if).value = 4096u16
    #GBA::Interrupts::HAL.if = GBA::Interrupts::HAL::IRQ_KEYPAD
  end
  
  while true
  end
end

