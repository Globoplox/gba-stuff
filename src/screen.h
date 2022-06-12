#ifndef SCREEN_H
#define SCREEN_H

#define rgb(r, g, b) ((r) + (g << 5) + (b << 10))
#define WIDTH 240
#define HEIGHT 160

// Screen buffer, defined in linker script
volatile extern unsigned short VRAM[HEIGHT][WIDTH];

// Display control IO register
volatile extern unsigned short DISPCNT;

#define DISPCNT_MODE_0 0b000
#define DISPCNT_MODE_1 0b001
#define DISPCNT_MODE_2 0b010
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

#endif
