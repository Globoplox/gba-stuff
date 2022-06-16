
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

void do_it() {
  // [tile_index][row][column] = palette index
  VRAM.tilesets[3].d_tiles[37][0][0] = 42;
}


int main() {
  // [tilemap][row][column] = tile_index
  VRAM.tilemaps[0][0][0] = 37;
  do_it();
  PALETTE.backgrounds[42] = rgb(0b1111, 0b11111, 0);
  BG0CNT = BGCNT_SIZE_32X32 | BGCNT_COLOR_8BPP | (0 << BGCNT_TILEMAP_INDEX) | (3 << BGCNT_TILESET_INDEX);
  DISPCNT = DISPCNT_MODE_TILE_0 | DISPCNT_BACKGROUND_0;
  while (1) {};
}

/*
int main() {
  /////////// Tilemap, Y, X
  VRAM.tilemaps[2][7][7] = 42 | (2 << SCRN_ENTRY_PALETTE_INDEX);
  VRAM.tilemaps[2][8][7] = 42 | (2 << SCRN_ENTRY_PALETTE_INDEX);
  VRAM.tilemaps[2][9][7] = 42 | (2 << SCRN_ENTRY_PALETTE_INDEX);
  //VRAM.tilemaps[2][10][7] = 43;
  //VRAM.tilemaps[2][10][8] = 43;
  //VRAM.tilemaps[2][10][9] = 43;

  do_it();
  //VRAM.tilesets[3].s_tiles[42][0][0] = (unsigned char)(5 | (7 << 4));
  //VRAM.tilesets[3].d_tiles[42][1][0] = 32;//G
  //VRAM.tilesets[3].d_tiles[42][0][2] = (unsigned char)29;//B

  //VRAM.tilesets[3].d_tiles[43][0][0] = 29;//B
  //VRAM.tilesets[3].d_tiles[43][1][1] = 32;//G
  
  //PALETTE.backgrounds[96] = rgb(0b11111, 0, 0);
  //PALETTE.backgrounds[29] = rgb(0, 0, 0b11111);
  //PALETTE.backgrounds[32] = rgb(0, 0b11111, 0);
  PALETTE.backgrounds[2*16+5] = rgb(0b1111, 0b11111, 0);
  PALETTE.backgrounds[2*16+7] = rgb(0, 0b11111, 0b1111);

  // Starting at tilemap 2/32 and tileset 3/4.
  BG0CNT = BGCNT_SIZE_32X32 | BGCNT_COLOR_4BPP  | (2 << BGCNT_TILEMAP_INDEX) | (3 << BGCNT_TILESET_INDEX);
  //BG0CNT = BGCNT_SIZE_32X32 | BGCNT_COLOR_8BPP  | (2 << BGCNT_TILEMAP_INDEX) | (3 << BGCNT_TILESET_INDEX);
  // Tiled mode regular background, enable background 0
  // Tilemap and tileset share the same memory, so the must not overlap.
  DISPCNT = DISPCNT_MODE_TILE_0 | DISPCNT_BACKGROUND_0;
  
  //VRAM.bitmap[80][120] = rgb(0b11111, 0b11111, 0);
  //VRAM.bitmap[80][136] = rgb(0, 0b11111, 0b11111);
  while (1) {};
}
*/
