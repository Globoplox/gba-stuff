#include "screen.h"

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
