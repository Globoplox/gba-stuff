
#include "common.h"
#include "screen.h"
#include "interrupt.h"
//#include "keypad.h"

extern unsigned short KEYCNT;

void ARM irq_handler() {
  //*((char*)0xffffffff) = 0;//Crash ?
  //VRAM[96][120] = rgb(0b11111, 0, 0b11111);
  /*if (IF.vblank) {
    //VRAM[96][120] = rgb(0b11111, 0, 0b11111);
    IF = (struct Interrupts) { .vblank = ENABLED }; // This acknowledge that the interrupt has been handled.
    }*/
  if (IF.keypad) {
    VRAM[96][120] = rgb(0b11111, 0, 0b11111);
    IF = (struct Interrupts) { .keypad = ENABLED }; // This acknowledge that the interrupt has been handled.
  }
}

int main() {
  DISPCNT = (typeof(DISPCNT)) { .mode = 3, .background_2 = ENABLED };
  VRAM[80][120] = rgb(0b11111, 0b11111, 0);
  VRAM[80][136] = rgb(0, 0b11111, 0b11111);
  //VRAM[96][120] = rgb(0b11111, 0, 0b11111);

  //KEYCNT = (typeof(KEYCNT)) { .a = ENABLED, .enable = ENABLED };
  KEYCNT = 0b0100000000000001;
  IE = (struct Interrupts) { .keypad = ENABLED };

  //DISPSTAT = (typeof(DISPSTAT)) { .vblank = ENABLED };
  //IE = (struct Interrupts) { .vblank = ENABLED, .keypad = ENABLED };

  IRQ_HANDLER = irq_handler;
  IME = 0xffff;
}
