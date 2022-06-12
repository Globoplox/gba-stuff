/*#include "interrupt.h"
11;rgb:fbfb/f1f1/c7c7
#define rgb(r, g, b) ((r) + (g << 5) + (b << 10))
#define WIDTH 240
#define HEIGHT 160
#define VRAM_ADDR ((unsigned short *)(0x6000000))
#define DISPCNT	(*(volatile unsigned long *)(0x4000000))
unsigned short *lcd = (unsigned short *)(VRAM_ADDR);
11;rgb:fbfb/f1f1/c7c7
void __attribute__((target ("arm"))) irq_keypad_handler(Interrupts)  {
  DISPCNT = 0x403;
  for (unsigned x = 0; x < WIDTH; x++)
    for (unsigned y = 0; y < HEIGHT; y ++) lcd[x + (y * WIDTH)] = rgb(0, 31, 0);   
};
*/

//int main() {

//  while(1);

    /*IRQ_start();
  IRQ_enable(KEYPAD);
  IRQ_set(KEYPAD, irq_keypad_handler);
  while (1);*/
    //}


#include "screen.h"

int main() {

  // Do the same, one is ugly but explicit, two is magic but nice.
  //DISPCNT = (typeof(DISPCNT)) { .mode = 3, .background_2 = 1 };
  DISPCNT.value = 0x0403;

  VRAM[80][120] = rgb(0b11111, 0b11111, 0);
  VRAM[80][136] = rgb(0, 0b11111, 0b11111);
  VRAM[96][120] = rgb(0b11111, 0, 0b11111);
}
