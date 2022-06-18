#include "screen.h"

void do_it() {
  int column = 0;
  int row = 0;
  VRAM.tilesets[0].d_tiles[37][row][column >> 1] |= 42 << ((column & 1) ? 8 : 0);
  column = 1;
  VRAM.tilesets[0].d_tiles[37][row][column >> 1] |= 43 << ((column & 1) ? 8 : 0);
}


int main() {
  // [tilemap][row][column] = tile_index
  VRAM.tilemaps[20][0][0] = 37;
  do_it();
  PALETTE.backgrounds[42] = rgb(0b11111, 0b11111, 0);
  PALETTE.backgrounds[43] = rgb(0, 0, 0b11111);
  BG0CNT = BGCNT_SIZE_32X32 | BGCNT_COLOR_8BPP | (20 << BGCNT_TILEMAP_INDEX) | (0 << BGCNT_TILESET_INDEX);
  DISPCNT = DISPCNT_MODE_TILE_0 | DISPCNT_BACKGROUND_0;
  while (1) {};
}
