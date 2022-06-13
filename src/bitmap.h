#ifndef BITMAP_H
#define BITMAP_H

#define rgb(r, g, b) ((r) + (g << 5) + (b << 10))
#define WIDTH 240
#define HEIGHT 160

// Screen buffer, defined in linker script
volatile extern unsigned short VRAM[HEIGHT][WIDTH];

#endif
