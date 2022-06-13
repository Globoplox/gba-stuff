
#include "common.h"
#include "screen.h"
#include "interrupt.h"
#include "keypad.h"
/*
void ARM irq_handler() {
  if ((IF & IRQ_KEYPAD) == IRQ_KEYPAD) {
    VRAM.bitmap[96][120] = rgb(0b11111, 0b0000, 0b11111);
    IF = IRQ_KEYPAD;
  }
}

int main() {
  DISPCNT = DISPCNT_MODE_3 | DISPCNT_BACKGROUND_2;
  VRAM.bitmap[80][120] = rgb(0b11111, 0b11111, 0);
  VRAM.bitmap[80][136] = rgb(0, 0b11111, 0b11111);
  KEYCNT = KEYCNT_ENABLE_IRQ | KEY_A;
  IE = IRQ_KEYPAD;
  IRQ_HANDLER = irq_handler;
  IME = ENABLED;
  while (1) {};
}
*/

int main() {
  /////////// Tilemap, Y, X
  VRAM.tilemaps[2][7][7] = 42;
  VRAM.tilemaps[2][8][7] = 42;
  VRAM.tilemaps[2][9][7] = 42;
  //VRAM.tilemaps[2][10][7] = 43;
  //VRAM.tilemaps[2][10][8] = 43;
  //VRAM.tilemaps[2][10][9] = 43;

 test:
  VRAM.tilesets[3].d_tiles[42][0][0] = (unsigned char)96;//R
 test_end:
  VRAM.tilesets[3].d_tiles[42][1][0] = 32;//G
  VRAM.tilesets[3].d_tiles[42][0][2] = (unsigned char)29;//B

  //VRAM.tilesets[3].d_tiles[43][0][0] = 29;//B
  //VRAM.tilesets[3].d_tiles[43][1][1] = 32;//G
  
  PALETTE.backgrounds[96] = rgb(0b11111, 0, 0);
  PALETTE.backgrounds[29] = rgb(0, 0, 0b11111);
  PALETTE.backgrounds[32] = rgb(0, 0b11111, 0);

  // Starting at tilemap 2/32 and tileset 3/4.
  BG0CNT = BGCNT_SIZE_32X32 | BGCNT_COLOR_8BPP  | (2 << BGCNT_TILEMAP_INDEX) | (3 << BGCNT_TILESET_INDEX);
  // Tiled mode regular background, enable background 0
  // Tilemap and tileset share the same memory, so the must not overlap.
  DISPCNT = DISPCNT_MODE_TILE_0 | DISPCNT_BACKGROUND_0;
  
  //VRAM.bitmap[80][120] = rgb(0b11111, 0b11111, 0);
  //VRAM.bitmap[80][136] = rgb(0, 0b11111, 0b11111);
  while (1) {};
}
