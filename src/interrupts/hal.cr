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
