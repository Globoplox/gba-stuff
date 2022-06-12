#ifndef SCREEN_H
#define SCREEN_H

#define rgb(r, g, b) ((r) + (g << 5) + (b << 10))
#define WIDTH 240
#define HEIGHT 160

// Screen buffer, defined in linker script
volatile extern unsigned short VRAM[HEIGHT][WIDTH];

// Display control IO register
volatile extern union {
  unsigned short value;
  struct {
    // Display mode
    unsigned short mode : 3;
    // Read only Set when running in GBC mode
    unsigned short is_gbc : 1;
    // Select the displayed page in mode 4 and 5 (flipping for smoth annimation)
    unsigned short page : 1;
    // Set to allow to access OAM during VBlank
    unsigned short access_oam : 1;
    // Select the mapping mode
    unsigned short mapping_mode : 1;
    // Set to force screen blank
    unsigned short blank : 1;
    // Enable backgrounds
    unsigned short background_0 : 1;
    unsigned short background_1 : 1;
    unsigned short background_2 : 1;
    unsigned short background_3 : 1;
    // Enable sprites
    unsigned short object : 1;
    // Enable windows
    unsigned short window_0 : 1;
    unsigned short window_1 : 1;
    unsigned short object_window : 1;
  };
} DISPCNT;


// Display status IO register
volatile extern union {
  unsigned short value;
  struct {
    // Read only, set during vblank
    unsigned short vblank : 1;
    // Read only, set during hblank
    unsigned short hblank : 1;
    // Read only, set when vcount is equal to vcount_value 
    unsigned short vcount_trigger : 1;
    // Set to require interrupt on vblank
    unsigned short vblank_irq : 1;
    // Set to require interrupt on hblank
    unsigned short hblank_irq : 1;
    // Set to require interrupt when vcount is equal to vcount_value
    unsigned short vcount_irq : 1;
    unsigned char : 0;
    // The value of vcount at which vcount_trigger should be set and an interrupted should be fired (if vcount_irq is set) 
    unsigned char vcount_value : 8;
  };
} DISPSTAT;

// Display I/O register, current scanline being drawn
volatile extern unsigned short VCOUNT;


#endif
