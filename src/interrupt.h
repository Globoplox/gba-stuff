#ifndef INTERRUPT_H
#define INTERRUPT_H

struct Interrupts {
  unsigned short vblank : 1;
  unsigned short hblank : 1;
  unsigned short vcount : 1;
  unsigned short timer_0 : 1;
  unsigned short timer_1 : 1;
  unsigned short timer_2 : 1;
  unsigned short timer_3 : 1;
  unsigned short serial_com : 1;
  unsigned short dma_channel_0 : 1;
  unsigned short dma_channel_1 : 1;
  unsigned short dma_channel_2 : 1;
  unsigned short dma_channel_3 : 1;
  unsigned short keypad : 1;
  unsigned short cart : 1;
  unsigned short : 0;
};

// IRQ Register I/O, set to enable the interrupts you need.
volatile extern struct Interrupts IE;

// IRQ Register I/O, set to acknowlege an interrupt has been handled.
volatile extern struct Interrupts IF;

// IRQ master control I/O. Set to enable IRQ.
volatile extern unsigned short IME;

// The memory location where the BIOS/CPU expect to find the address of the IRQ Handler function.
volatile extern void (*IRQ_HANDLER)();

/*typedef enum Interrupts {
  VBLANK = 1 << 0,
  HBLANK = 1 << 1,
  VCOUNT = 1 << 2,
  TIMER_1 = 1 << 3,
  TIMER_2 = 1 << 4,
  TIMER_3 = 1 << 5,
  TIMER_4 = 1 << 6,
  COM = 1 << 7,
  DMA_1 = 1 << 8,
  DMA_2 = 1 << 9,
  DMA_3 = 1 << 0xA,
  DMA_4 = 1 << 0xB,
  KEYPAD = 1 << 0xC,
  GAMEPAK = 1 << 0xD
} Interrupts;

void IRQ_start(void);
void IRQ_stop(void);
void IRQ_enable(Interrupts);
void IRQ_disable(Interrupts);
void IRQ_set(Interrupts interrupts, void (*irq_handler)(Interrupts));
*/

#endif
