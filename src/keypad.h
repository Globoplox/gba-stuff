#ifndef KEYPAD_H
#define KEYPAD_H

// Resgiter I/O for keypad interrupt control.
volatile extern struct {
  unsigned short a : 1;
  unsigned short b : 1;
  unsigned short select : 1;
  unsigned short start : 1;
  unsigned short right : 1;
  unsigned short left : 1;
  unsigned short up : 1;
  unsigned short down : 1;
  unsigned short r : 1;
  unsigned short l : 1;
  unsigned short : 4;
  unsigned short enable : 4;
  unsigned short mode : 4;
} KEYCNT;

#endif
