
INCLUDE "src/gba.ld"
SECTIONS
{
	 /* We will want to copy these data in VRAM, which is more efficient by pack of four byte.*/
	 /* We can't move unaligned read, we mighy unexpectedly get shifted */
	 /* So we  align on 4 bytes*/

	 
	   .palette.minimal : ALIGN(4)
	   {
             PALETTE_MINIMAL_DATA = .;
	     *(.palette.minimal);
	   } > pakrom1

	   PALETTE_MINIMAL_SIZE = . - PALETTE_MINIMAL_DATA;
	   
	 
	   .palette.other : ALIGN(4)
	   {
             PALETTE_OTHER_DATA = .;
	     *(.palette.other);
	   } > pakrom1

	   PALETTE_OTHER_SIZE = . - PALETTE_OTHER_DATA;
	   

	 
	   .tileset.minimal : ALIGN(4)
	   {
             TILESET_MINIMAL_DATA = .;
	     *(.tileset.minimal);
	   } > pakrom1

	   TILESET_MINIMAL_SIZE = . - TILESET_MINIMAL_DATA;
	   
	 
	   .tileset.other : ALIGN(4)
	   {
             TILESET_OTHER_DATA = .;
	     *(.tileset.other);
	   } > pakrom1

	   TILESET_OTHER_SIZE = . - TILESET_OTHER_DATA;
	   
}
