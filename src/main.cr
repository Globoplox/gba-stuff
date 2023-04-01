require "./primitives"
#require "./keypad"
#require "./screen/mode_3"
require "./interrupts/hal"
require "./bios"
require "./state"
require "./assets"

GBA::Assets.declare_palette base
GBA::Assets.declare_font base

fun gba_main : NoReturn
  GBA::Screen::HAL.dispstat = GBA::Screen::HAL::DISPTAT_VBLANK_INTERRUPT
  GBA::Interrupts::HAL.ie |= GBA::Interrupts::HAL::IRQ_VBLANK

  GBA::Interrupts::HAL.handler = ->do
    GBA::Interrupts::HAL.if = GBA::Interrupts::HAL::IRQ_VBLANK
    GBA::BIOS.if = GBA::Interrupts::HAL::IRQ_VBLANK
  end
  GBA::Interrupts::HAL.ime = 1

  # Load the base stuff we will use for the while game.
  GBA::Assets.copy_palette(
    pointerof(Palettes::Base.start).as(UInt32*),
    pointerof(Palettes::Base.size).address.to_u32!,
    to: 0
  )

  GBA::Assets.copy_bitpacked_font(
    pointerof(Fonts::Base.start).as(UInt32*),
    pointerof(Fonts::Base.size).address.to_u32!,
    index: 0u32, offset: 0x3u32, background: 0x1u32, foreground: 0x2u32
  )

  while true
    #Keypad.process_inputs
    State.call
    GBA::BIOS.vBlankIntrWait
    State.draw
  end
end
