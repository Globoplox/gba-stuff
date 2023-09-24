

require "./primitives"
require "./raise"
require "./interrupts"
require "./bios"
require "./state"
require "./assets"
require "./generated/assets"
require "./keypad"

fun gba_main : NoReturn
  # Screen::HAL.dispstat = Screen::HAL::DISPTAT_VBLANK_INTERRUPT
  #Interrupts.ie |= Interrupts::IRQ_VBLANK

  #Interrupts.handler = ->do
  #  Interrupts.if = Interrupts::IRQ_VBLANK
  #  BIOS.if = Interrupts::IRQ_VBLANK
  #end

  #Interrupts.ime = 1
  
  #Assets::Base.load
  
  Assets::Base.load
  #Assets::BasePalette.load
  #Assets::Menu.load

  while true
  end

  # Assets.copy_palette(
  #   pointerof(Palettes::Base.start).as(UInt32*),
  #   pointerof(Palettes::Base.size).address.to_u32!,
  #   index: 0, offset: 0
  # )

  # Assets.copy_palette(
  #   pointerof(Palettes::Menu.start).as(UInt32*),
  #   pointerof(Palettes::Menu.size).address.to_u32!,
  #   index: 0, offset: 0x3
  # )

  # Assets.copy_bitpacked_font(
  #   pointerof(Tilesets::Font.start).as(UInt32*),
  #   pointerof(Tilesets::Font.size).address.to_u32!,
  #   index: 0u32, offset: 0x3u32, background: 0x1u32, foreground: 0x2u32
  # )

  # Assets.copy_tileset(
  #   pointerof(Tilesets::Menu.start).as(UInt32*),
  #   pointerof(Tilesets::Menu.size).address.to_u32!,
  #   index: 0u32, offset: 94u32
  # )

  while true
    Keypad.process_inputs
    State.call
    BIOS.vBlankIntrWait
    State.draw
  end
end

gba_main
