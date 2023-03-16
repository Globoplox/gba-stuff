require "./primitives"
require "./screen/hal"
require "./screen/mode_3"
require "./screen/mode_4"
require "./keypad/hal"
require "./interrupts/hal"

# Instead of using the crystal `main` calling the `__crystal_main` which contain the program (the top level),
# We use our own main called manually in the startup code.
# This way we can completely ignore the startup code initialized by crystal.
fun gba_main : NoReturn
  # Set a few pixels, then flip between mode 4 two pages every time button A is down.
  # Note: in MGBA, default keyboard binding for button A is 'x'.

  GBA::Screen::Mode3.init
  # Works
  GBA::Screen::HAL.vram.access_16b[10 &* 240 &+ 10] = 0x00ffu16
  # Dont... Yet. 
  GBA::Screen::HAL.vram.mode_3_test[1][1] = 0xffffu16
  GBA::Screen::HAL.vram.mode_3_test[2][1] = 0xffffu16
  GBA::Screen::HAL.vram.mode_3_test[3][1] = 0xffffu16
  GBA::Screen::HAL.vram.mode_3_test[3][3] = 0xffffu16

  # GBA::Screen::Mode3.init
  # GBA::Screen::Mode3[0, 0] = 0xffffu16
  # GBA::Screen::Mode3[1, 0] = 0xffffu16
  # GBA::Screen::HAL.palette.backgrounds[0xff] = 0b11111
  # GBA::Screen::HAL.palette.backgrounds[0xaa] = 0b1111100000
  # GBA::Screen::Mode4.init
  # GBA::Screen::Mode4[1, 0] = 0xaau16
  # GBA::Screen::Mode4[2, 0] = 0xaau16
  # GBA::Screen::Mode4.flip
  # GBA::Screen::Mode4[1, 0] = 0xaau16
  # GBA::Screen::Mode4[2, 0] = 0xaau16

  # GBA::Keypad::HAL.keycnt = GBA::Keypad::HAL::KEYCNT_ENABLE_IRQ | GBA::Keypad::HAL::KEY_A
  # GBA::Interrupts::HAL.ie |= GBA::Interrupts::HAL::IRQ_KEYPAD
  # GBA::Interrupts::HAL.handler = ->do
  #   GBA::Screen::Mode4.flip
  #   GBA::Interrupts::HAL.if = GBA::Interrupts::HAL::IRQ_KEYPAD
  # end
  # GBA::Interrupts::HAL.ime = 1
  
  while true
  end
end
