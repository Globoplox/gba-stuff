#ifndef SCREEN_H
#define SCREEN_H

// Display control IO register
volatile extern unsigned short DISPCNT;

#define DISPCNT_MODE_TILE_0 0 // BG0, BG1, BG2, BG3 as regular BG
#define DISPCNT_MODE_TILE_1 1 // BG0, BG1 as regular BG, B2 as affine BG
#define DISPCNT_MODE_TILE_2 2 // BG2, BG3 as affine BG
#define DISPCNT_MODE_3 0b011
#define DISPCNT_MODE_4 0b100
#define DISPCNT_MODE_5 0b101
#define DISPCNT_IS_GBC        1 << 3
#define DISPCNT_PAGE_SELECT   1 << 4
#define DISPCNT_ACCESS_OAM    1 << 5
#define DISPCNT_MAPPING_MODE  1 << 6
#define DISPCNT_BLANK         1 << 7
#define DISPCNT_BACKGROUND_0  1 << 8
#define DISPCNT_BACKGROUND_1  1 << 9
#define DISPCNT_BACKGROUND_2  1 << 0xA
#define DISPCNT_BACKGROUND_3  1 << 0xB
#define DISPCNT_OBJECT        1 << 0xC
#define DISPCNT_WINDOW_0      1 << 0xD
#define DISPCNT_WINDOW_2      1 << 0xE
#define DISPCNT_WINDOW_OBJECT 1 << 0xF

// Display status IO register
volatile extern struct {
  unsigned char cfg;
  unsigned char vcount_value : 8;
} DISPSTAT;

#define DISPSTAT_VBLANK 1
#define DISPSTAT_HBLANK 1 << 1
#define DISPSTAT_VCOUNT_TRIGGER 1 << 2
#define DISPSTAT_VBLANK_IRQ 1 << 3
#define DISPSTAT_HBLANK_IRQ 1 << 4
#define DISPSTAT_VCOUNT_IRQ 1 << 5

// Display I/O register, current scanline being drawn
volatile extern unsigned short VCOUNT;

// Screen dimensions
#define WIDTH 240
#define HEIGHT 160

// Screen Mode for DISPCNT I/O register
#define DISPCNT_MODE_TILE_0 0 // BG0, BG1, BG2, BG3 as regular BG
#define DISPCNT_MODE_TILE_1 1 // BG0, BG1 as regular BG, B2 as affine BG
#define DISPCNT_MODE_TILE_2 2 // BG2, BG3 as affine BG

// Background control IO registers
volatile extern unsigned short BG0CNT;
volatile extern unsigned short BG1CNT;
volatile extern unsigned short BG2CNT;
volatile extern unsigned short BG4CNT;

#define BGCNT_PRIORITY 0b11
#define BGCNT_CHARBLOCK 0b11 << 2
#define BGCNT_MOSAIC 1 << 5
#define BGCNT_COLOR_4BPP 0 << 6
#define BGCNT_COLOR_8BPP 1 << 6
#define BGCNT_BASE_BLOCK 0b11111 << 7
#define BGCNT_AFF_WRAPPING 1 << 0xC
#define BGCNT_SIZE_32X32 0b00 << 0xD
#define BGCNT_SIZE_64X32 0b01 << 0xD
#define BGCNT_SIZE_32X64 0b10 << 0xD
#define BGCNT_SIZE_64X64 0b11 << 0xD
#define BGCNT_AFF_SIZE_16X16 0b00 << 0xD
#define BGCNT_AFF_SIZE_32X32 0b01 << 0xD
#define BGCNT_AFF_SIZE_64X64 0b10 << 0xD
#define BGCNT_AFF_SIZE_128X128 0b11 << 0xD

// Background horizontal offset IO registers, write only
volatile extern unsigned short BG0HOFS;
volatile extern unsigned short BG1HOFS;
volatile extern unsigned short BG2HOFS;
volatile extern unsigned short BG4HOFS;

// Background vertical offset IO registers, write only
volatile extern unsigned short BG0VOFS;
volatile extern unsigned short BG1VOFS;
volatile extern unsigned short BG2VOFS;
volatile extern unsigned short BG4VOFS;

// A screen entry is a reference to a tile
typedef unsigned short screen_entry;
#define SCRN_ENTRY_TILE_INDEX 0b1111111111
#define SCRN_ENTRY_HFLIP 1 << 9
#define SCRN_ENTRY_VFLIP 1 << 0xA
#define SCRN_ENTRY_PALETTE 0b1111 << 0xB

// A screen block is a block of 32x32 screen entry
typedef screen_entry[32*32] screen_block;

// A char block is a tileset, aka a big pack of 8x8 px tiles
typedef union {
  tile_4bpp s_tiles[512];
  tile_8pp  d_tiles[256];
} char_block;

// Video memory
volatile extern union {
  char_block tilesets[4];
  screen_block tilemaps[32];
  color bitmap[HEIGHT][WIDTH];
} VRAM;

// 15 bpp RGB color entry. Used in palette or 
typedef unsigned short color;
#define rgb(r, g, b) (color)((r) + (g << 5) + (b << 10))
#define TRANSPARENT (color)0

#endif
