#include "screen.h"

extern int TILESET_DATA_SIZE;
extern int PALETTE_DATA_SIZE;
extern char TILESET_DATA[];
extern color PALETTE_DATA[];

// // Need smart transformation
void set_big_tile(row, column, tile_row, tile_column, tileset_width) {
  //0, 1, 3
  VRAM.tilemaps[20][row * 2][column * 2] = ((tile_row * 2) * (tileset_width * 2)) + (tile_column * 2);
  VRAM.tilemaps[20][row * 2][column * 2 + 1] = ((tile_row * 2) * (tileset_width * 2)) + (tile_column * 2) + 1;
  VRAM.tilemaps[20][row * 2 + 1][column * 2] = ((tile_row * 2 + 1) * (tileset_width * 2)) + (tile_column * 2);
  VRAM.tilemaps[20][row * 2 + 1][column * 2 + 1] = ((tile_row * 2 + 1) * (tileset_width * 2)) + (tile_column * 2) + 1;
}

int main() {
  set_big_tile(0,0,0,0,3);
  set_big_tile(0,1,0,1,3);
  set_big_tile(0,2,0,1,3);
  set_big_tile(0,2,0,1,3);
  set_big_tile(0,3,0,2,3);
  set_big_tile(1,0,1,0,3);
  set_big_tile(2,0,1,0,3);
  set_big_tile(3,0,2,0,3);
  set_big_tile(3,1,0,2,3);

  // Copy palette
 for (int i = 0; i < (int)&PALETTE_DATA_SIZE / sizeof(int); i++)
   ((int*)PALETTE.backgrounds)[i] = ((int*)PALETTE_DATA)[i];

 for (int i = 0; i < (int)(&TILESET_DATA_SIZE) / sizeof(int); i++)
   ((int*)(VRAM.tilesets[0].d_tiles[0]))[i] = ((int*)TILESET_DATA)[i];
      
  BG0CNT = BGCNT_SIZE_32X32 | BGCNT_COLOR_8BPP | (20 << BGCNT_TILEMAP_INDEX) | (0 << BGCNT_TILESET_INDEX);
  DISPCNT = DISPCNT_MODE_TILE_0 | DISPCNT_BACKGROUND_0;
  while (1) {};
}
