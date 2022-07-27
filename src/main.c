#include "screen.h"
#include "assets.h"

// // Need smart transformation
void set_big_tile(int row, int column, int tile_row, int tile_column, int tileset_width) {
  // The four tiles that composes the 16x16 tile, counterclockwise (topleft, botleft, botright, topright
  screen_entry big_tile[] = {
    ((tile_row * 2) * (tileset_width * 2)) + (tile_column * 2),
    ((tile_row * 2 + 1) * (tileset_width * 2)) + (tile_column * 2),
    ((tile_row * 2 + 1) * (tileset_width * 2)) + (tile_column * 2) + 1,
    ((tile_row * 2) * (tileset_width * 2)) + (tile_column * 2) + 1
  };
  
  VRAM.tilemaps[20][row * 2][column * 2] = big_tile[0];
  VRAM.tilemaps[20][row * 2][column * 2 + 1] = big_tile[1];
  VRAM.tilemaps[20][row * 2 + 1][column * 2] = big_tile[2];
  VRAM.tilemaps[20][row * 2 + 1][column * 2 + 1] = big_tile[3];
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


  set_big_tile(4,4,1,2,3);

  
  
  // Copy palette
 for (int i = 0; i < (int)&PALETTE_MINIMAL_SIZE / sizeof(int); i++)
   ((int*)PALETTE.backgrounds)[i] = ((int*)PALETTE_MINIMAL_DATA)[i];

 for (int i = 0; i < (int)(&TILESET_MINIMAL_SIZE) / sizeof(int); i++)
   ((int*)(VRAM.tilesets[0].d_tiles[0]))[i] = ((int*)TILESET_MINIMAL_DATA)[i];
      
  BG0CNT = BGCNT_SIZE_32X32 | BGCNT_COLOR_8BPP | (20 << BGCNT_TILEMAP_INDEX) | (0 << BGCNT_TILESET_INDEX);
  DISPCNT = DISPCNT_MODE_TILE_0 | DISPCNT_BACKGROUND_0;
  while (1) {};
}
