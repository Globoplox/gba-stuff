require "./primitives"
require "./keypad"
require "./screen/mode_3"
require "./interrupts/hal"
require "./bios"
require "./state"

fun gba_main : NoReturn
  GBA::Screen::HAL.dispstat = GBA::Screen::HAL::DISPTAT_VBLANK_INTERRUPT
  GBA::Interrupts::HAL.ie |= GBA::Interrupts::HAL::IRQ_VBLANK

  # TODO: do not make a proc literal this way to avoid having the runtime check
  GBA::Interrupts::HAL.handler = ->do
    GBA::Interrupts::HAL.if = GBA::Interrupts::HAL::IRQ_VBLANK
    GBA::BIOS.if = GBA::Interrupts::HAL::IRQ_VBLANK
  end
  GBA::Interrupts::HAL.ime = 1

  while true
    #Keypad.process_inputs
    State.call
    GBA::BIOS.vBlankIntrWait
    State.draw
  end
end
