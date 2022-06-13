
#include "common.h"
#include "screen.h"
#include "bitmap.h"
#include "interrupt.h"
#include "keypad.h"

void ARM irq_handler() {
  if ((IF & IRQ_KEYPAD) == IRQ_KEYPAD) {
    VRAM[96][120] = rgb(0b11111, 0, 0b11111);
    IF = IRQ_KEYPAD;
  }
}

int main() {
  DISPCNT = DISPCNT_MODE_3 | DISPCNT_BACKGROUND_2;
  VRAM[80][120] = rgb(0b11111, 0b11111, 0);
  VRAM[80][136] = rgb(0, 0b11111, 0b11111);
  KEYCNT = KEYCNT_ENABLE_IRQ | KEY_A;
  IE = IRQ_KEYPAD;
  IRQ_HANDLER = irq_handler;
  IME = ENABLED;
  while (1) {};
}
