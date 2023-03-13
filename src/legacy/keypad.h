#ifndef KEYPAD_H
#define KEYPAD_H

// Resgiter I/O for keypad input control.
// Note the bit are set by default, and clear during input.
volatile extern unsigned short KEYINPUT;

#define KEY_A 1
#define KEY_B 1 << 1
#define KEY_SELECT 1 << 2
#define KEY_START 1 << 3
#define KEY_RIGHT 1 << 4
#define KEY_LEFT 1 << 5
#define KEY_UP 1 << 6
#define KEY_DOWN 1 << 7
#define KEY_L 1 << 8
#define KEY_R 1 << 9

// Resgiter I/O for keypad interrupt control.
volatile extern unsigned short KEYCNT;

#define KEYCNT_ENABLE_IRQ 1 << 0xE
#define KEYCNT_MODE 1 << 0xF

#endif
