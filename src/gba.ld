/* See https://problemkaputt.de/gbatek.htm#gbamemorymap */

MEMORY
{
       bios    : ORIGIN = 0x00000000, LENGTH = 16k
       ewram   : ORIGIN = 0x02000000, LENGTH = 256k /* 16 bits bus and 3 cycles to access, best fit for THUMB code. */
       iwram   : ORIGIN = 0x03000000, LENGTH = 32k  /* 32 bits bus and 1 cycle for access.
       	       	/* Last 0xff bytes are reserved for BIOS/Irq stack and other fixed stuff, */
						    /* including the last four bytes of of iwram 0x03007FFC are reserved for the address of the interrupt handler */
       	       	/* Which MUST be ARM code (and not THUMB). */ 
       io      : ORIGIN = 0x04000000, LENGTH = 1k
       pal     : ORIGIN = 0x05000000, LENGTH = 1k
       vram    : ORIGIN = 0x06000000, LENGTH = 96k
       oam     : ORIGIN = 0x07000000, LENGTH = 1k
       pakrom1 : ORIGIN = 0x08000000, LENGTH = 32k  /* 16 bit bus. Configurable wait states: http://problemkaputt.de/gbatek-gba-system-control.htm */
       pakrom2 : ORIGIN = 0x0A000000, LENGTH = 32k  /* The sizes may vary */
       pakrom3 : ORIGIN = 0x0C000000, LENGTH = 32k
       pakram  : ORIGIN = 0x0E000000, LENGTH = 1k   /* 8 bits bus, for save data */
}
  
/* Various important address */
IRQ_HANDLER = 0x03007FFC; /* ORIGIN(iwram) - 0x4;*/ /* Expected by BIOS/  */
BIOS_IF = 0x03007FF8; /* ORIGIN(iwram) - 0x8;*/ /* BIOS software interrupt acknowledge register  */
  
IRQ_STACK_POINTER = ORIGIN(iwram) - 0x60;
USER_STACK_POINTER = IRQ_STACK_POINTER - 0x40;
VRAM = ORIGIN(vram);
PALETTE = ORIGIN(pal);

/* Input/Ouput registers */

/* LCD IO */
DISPCNT = 4000000h; /* Size: I/O, Registers 2    R/W  DISPCNT   LCD Control */
DISPSTAT = 4000004h; /* Size: 2, R/W General LCD Status (STAT,LYC) */
VCOUNT = 4000006h; /* Size: 2, R Vertical Counter (LY) */
BG0CNT = 4000008h; /* Size: 2, R/W BG0 Control */
BG1CNT = 400000Ah; /* Size: 2, R/W BG1 Control */
BG2CNT = 400000Ch; /* Size: 2, R/W BG2 Control */
BG3CNT = 400000Eh; /* Size: 2, R/W BG3 Control */
BG0HOFS = 4000010h; /* Size: 2, W BG0 X-Offset */
BG0VOFS = 4000012h; /* Size: 2, W BG0 Y-Offset */
BG1HOFS = 4000014h; /* Size: 2, W BG1 X-Offset */
BG1VOFS = 4000016h; /* Size: 2, W BG1 Y-Offset */
BG2HOFS = 4000018h; /* Size: 2, W BG2 X-Offset */
BG2VOFS = 400001Ah; /* Size: 2, W BG2 Y-Offset */
BG3HOFS = 400001Ch; /* Size: 2, W BG3 X-Offset */
BG3VOFS = 400001Eh; /* Size: 2, W BG3 Y-Offset */
BG2PA = 4000020h; /* Size: 2, W BG2 Rotation/Scaling Parameter A (dx) */
BG2PB = 4000022h; /* Size: 2, W BG2 Rotation/Scaling Parameter B (dmx) */
BG2PC = 4000024h; /* Size: 2, W BG2 Rotation/Scaling Parameter C (dy) */
BG2PD = 4000026h; /* Size: 2, W BG2 Rotation/Scaling Parameter D (dmy) */
BG2X = 4000028h; /* Size: 4, W BG2 Reference Point X-Coordinate */
BG2Y = 400002Ch; /* Size: 4, W BG2 Reference Point Y-Coordinate */
BG3PA = 4000030h; /* Size: 2, W BG3 Rotation/Scaling Parameter A (dx) */
BG3PB = 4000032h; /* Size: 2, W BG3 Rotation/Scaling Parameter B (dmx) */
BG3PC = 4000034h; /* Size: 2, W BG3 Rotation/Scaling Parameter C (dy) */
BG3PD = 4000036h; /* Size: 2, W BG3 Rotation/Scaling Parameter D (dmy) */
BG3X = 4000038h; /* Size: 4, W BG3 Reference Point X-Coordinate */
BG3Y = 400003Ch; /* Size: 4, W BG3 Reference Point Y-Coordinate */
WIN0H = 4000040h; /* Size: 2, W Window 0 Horizontal Dimensions */
WIN1H = 4000042h; /* Size: 2, W Window 1 Horizontal Dimensions */
WIN0V = 4000044h; /* Size: 2, W Window 0 Vertical Dimensions */
WIN1V = 4000046h; /* Size: 2, W Window 1 Vertical Dimensions */
WININ = 4000048h; /* Size: 2, R/W Inside of Window 0 and 1 */
WINOUT = 400004Ah; /* Size: 2, R/W Inside of OBJ Window & Outside of Windows */
MOSAIC = 400004Ch; /* Size: 2, W Mosaic Size */
BLDCNT = 4000050h; /* Size: 2, R/W Color Special Effects Selection */
BLDALPHA = 4000052h; /* Size: 2, R/W Alpha Blending Coefficients */
BLDY = 4000054h; /* Size: 2, W Brightness (Fade-In/Out) Coefficient */

/* SOUND IO */
SOUND1CNT_L = 4000060h; /* Size: A, R/W  SOUND1CNT_L Channel 1 Sweep register       (NR10) */
SOUND1CNT_H = 4000062h; /* Size: 2, R/W Channel 1 Duty/Length/Envelope (NR11, NR12) */
SOUND1CNT_X = 4000064h; /* Size: 2, R/W Channel 1 Frequency/Control    (NR13, NR14) */
SOUND2CNT_L = 4000068h; /* Size: 2, R/W Channel 2 Duty/Length/Envelope (NR21, NR22) */
SOUND2CNT_H = 400006Ch; /* Size: 2, R/W Channel 2 Frequency/Control    (NR23, NR24) */
SOUND3CNT_L = 4000070h; /* Size: 2, R/W Channel 3 Stop/Wave RAM select (NR30) */
SOUND3CNT_H = 4000072h; /* Size: 2, R/W Channel 3 Length/Volume        (NR31, NR32) */
SOUND3CNT_X = 4000074h; /* Size: 2, R/W Channel 3 Frequency/Control    (NR33, NR34) */
SOUND4CNT_L = 4000078h; /* Size: 2, R/W Channel 4 Length/Envelope      (NR41, NR42) */
SOUND4CNT_H = 400007Ch; /* Size: 2, R/W Channel 4 Frequency/Control    (NR43, NR44) */
SOUNDCNT_L = 4000080h; /* Size: 2, R/W Control Stereo/Volume/Enable   (NR50, NR51) */
SOUNDCNT_H = 4000082h; /* Size: 2, R/W Control Mixing/DMA Control */
SOUNDCNT_X = 4000084h; /* Size: 2, R/W Control Sound on/off           (NR52) */
SOUNDBIAS = 4000088h; /* Size: 2, BIOS Sound PWM Control */
WAVE_RAM = 4000090h; /* Size: 2x10h, R/W Channel 3 Wave Pattern RAM (2 banks!!) */
FIFO_A = 40000A0h; /* Size: 4, W Channel A FIFO, Data 0-3 */
FIFO_B = 40000A4h; /* Size: 4, W Channel B FIFO, Data 0-3 */

/* DMA IO (Optimized copy) */
DMA0SAD = 40000B0h;  /* Size: 4 W  DMA 0 Source Address */
DMA0DAD = 40000B4h; /* Size: 4, W DMA 0 Destination Address */
DMA0CNT_L = 40000B8h; /* Size: 2, W DMA 0 Word Count */
DMA0CNT_H = 40000BAh; /* Size: 2, R/W DMA 0 Control */
DMA1SAD = 40000BCh; /* Size: 4, W DMA 1 Source Address */
DMA1DAD = 40000C0h; /* Size: 4, W DMA 1 Destination Address */
DMA1CNT_L = 40000C4h; /* Size: 2, W DMA 1 Word Count */
DMA1CNT_H = 40000C6h; /* Size: 2, R/W DMA 1 Control */
DMA2SAD = 40000C8h; /* Size: 4, W DMA 2 Source Address */
DMA2DAD = 40000CCh; /* Size: 4, W DMA 2 Destination Address */
DMA2CNT_L = 40000D0h; /* Size: 2, W DMA 2 Word Count */
DMA2CNT_H = 40000D2h; /* Size: 2, R/W DMA 2 Control */
DMA3SAD = 40000D4h; /* Size: 4, W DMA 3 Source Address */
DMA3DAD = 40000D8h; /* Size: 4, W DMA 3 Destination Address */
DMA3CNT_L = 40000DCh; /* Size: 2, W DMA 3 Word Count */
DMA3CNT_H = 40000DEh; /* Size: 2, R/W DMA 3 Control */

/* TIMER IO */
TM0CNT_L = 4000100h; /* Size: 2  R/W Timer 0 Counter/Reload */
TM0CNT_H = 4000102h; /* Size: 2, R/W Timer 0 Control */
TM1CNT_L = 4000104h; /* Size: 2, R/W Timer 1 Counter/Reload */
TM1CNT_H = 4000106h; /* Size: 2, R/W Timer 1 Control */
TM2CNT_L = 4000108h; /* Size: 2, R/W Timer 2 Counter/Reload */
TM2CNT_H = 400010Ah; /* Size: 2, R/W Timer 2 Control */
TM3CNT_L = 400010Ch; /* Size: 2, R/W Timer 3 Counter/Reload */
TM3CNT_H = 400010Eh; /* Size: 2, R/W Timer 3 Control */

/* SERIAL (Part 1) IO */
SIODATA32 = 4000120h; /* Size: 4  R/W SIO Data (Normal-32bit Mode; shared with below) */
SIOMULTI0 = 4000120h; /* Size: 2, R/W SIO Data 0 (Parent)    (Multi-Player Mode) */
SIOMULTI1 = 4000122h; /* Size: 2, R/W SIO Data 1 (1st Child) (Multi-Player Mode) */
SIOMULTI2 = 4000124h; /* Size: 2, R/W SIO Data 2 (2nd Child) (Multi-Player Mode) */
SIOMULTI3 = 4000126h; /* Size: 2, R/W SIO Data 3 (3rd Child) (Multi-Player Mode) */
SIOCNT = 4000128h; /* Size: 2, R/W SIO Control Register */
SIOMLT_SEND = 400012Ah; /* Size: 2, R/W SIO Data (Local of MultiPlayer; shared below) */
SIODATA8 = 400012Ah; /* Size: 2, R/W SIO Data (Normal-8bit and UART Mode) */

/* KEYPAD IO */
KEYINPUT = 4000130h; /* Size: 2 R Key Status */
KEYCNT = 4000132h; /* Size: 2, R/W Key Interrupt Control */

/* SERIAL (Part 2° IO */
RCNT = 4000134h; /* Size: 2 R/W SIO Mode Select/General Purpose Data */
IR = 4000136h; /* Size: -, - Ancient - Infrared Register (Prototypes only) */
JOYCNT = 4000140h; /* Size: 2, R/W SIO JOY Bus Control */
JOY_RECV = 4000150h; /* Size: 4, R/W SIO JOY Bus Receive Data */
JOY_TRANS = 4000154h; /* Size: 4, R/W SIO JOY Bus Transmit Data */
JOYSTAT = 4000158h; /* Size: 2, R/? SIO JOY Bus Receive Status */

/* IRQ, WAITSTAE and POWER IO */
IE = 4000200h; /* Size: 2, R/W Interrupt Enable Register */
IF = 4000202h; /* Size: 2, R/W Interrupt Request Flags / IRQ Acknowledge */
WAITCNT = 4000204h; /* Size: 2, R/W Game Pak Waitstate Control */
IME = 4000208h; /* Size: 2, R/W Interrupt Master Enable Register */
POSTFLG = 4000300h; /* Size: 1, R/W Undocumented - Post Boot Flag */
HALTCNT = 4000301h; /* Size: 1, W Undocumented - Power Down Control */

SECTIONS
{
  /DISCARD/ :
  {
    *(.ARM.exidx*)
  }

  . = ORIGIN(pakrom1);

	.init :
	{
	  *(.init);
	} > pakrom1

	.text :
	{
	  *(.text*);
	} > pakrom1

  .rodata :
	{
	  *(.rodata*);
	} > pakrom1

  .bss :
	{
	  *(.bss*);
	} > iwram
}

