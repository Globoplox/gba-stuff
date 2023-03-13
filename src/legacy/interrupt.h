#ifndef INTERRUPT_H
#define INTERRUPT_H

// IRQ Register I/O, set to enable the interrupts you need.
volatile extern unsigned short IE;

// IRQ Register I/O, set to acknowlege an interrupt has been handled.
volatile extern unsigned short IF;

#define IRQ_VBLANK 1
#define IRQ_HBLANK 1 << 1
#define IRQ_VCOUNT 1 << 2
#define IRQ_TIMER_0 1 << 3
#define IRQ_TIMER_1 1 << 4
#define IRQ_TIMER_2 1 << 5
#define IRQ_TIMER_3 1 << 6
#define IRQ_SERIAL_COM 1 << 7
#define IRQ_DMA_0 1 << 8
#define IRQ_DMA_1 1 << 9
#define IRQ_DMA_2 1 << 0xA
#define IRQ_DMA_3 1 << 0xB
#define IRQ_KEYPAD 1 << 0xC
#define IRQ_CART 1 << 0xD

// IRQ master control I/O. Set to enable IRQ.
volatile extern unsigned short IME;

// The memory location where the BIOS/CPU expect to find the address of the IRQ Handler function.
volatile extern void (*IRQ_HANDLER)();

#endif
