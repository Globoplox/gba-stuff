require "./primitives"
require "./raise"
require "./interrupts"
require "./bios"
require "./state"
require "./assets"

Assets.declare_palette base
Assets.declare_font base

fun gba_main : NoReturn
  Screen::HAL.dispstat = Screen::HAL::DISPTAT_VBLANK_INTERRUPT
  Interrupts.ie |= Interrupts::IRQ_VBLANK

  Interrupts.handler = ->do
    Interrupts.if = Interrupts::IRQ_VBLANK
    BIOS.if = Interrupts::IRQ_VBLANK
  end
  Interrupts.ime = 1

  # Load the base stuff we will use for the while game.
  Assets.copy_palette(
    pointerof(Palettes::Base.start).as(UInt32*),
    pointerof(Palettes::Base.size).address.to_u32!,
    to: 0
  )

  Assets.copy_bitpacked_font(
    pointerof(Fonts::Base.start).as(UInt32*),
    pointerof(Fonts::Base.size).address.to_u32!,
    index: 0u32, offset: 0x3u32, background: 0x1u32, foreground: 0x2u32
  )

  while true
    #Keypad.process_inputs
    State.call
    BIOS.vBlankIntrWait
    State.draw
  end
end
