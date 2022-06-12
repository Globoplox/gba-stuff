.section ".init"
.arm // We boot in ARM ISA, not ARM THUMB ISA mode.
.align
	
header:	// The cartridge header, see http://problemkaputt.de/gbatek-gba-cartridge-header.htm
	
	b startup // Jump over header to real startup

h_logo:
	.zero 156 // Nintendo Logo
h_title:
	.ascii HEADER_TITLE // 12 Byte ascci title
	.zero 12 - (. - h_title)
h_code:
	.ascii HEADER_CODE // 4 Byte ascci title code
	.zero 4 - (. - h_code)
h_maker_code:
	.ascii HEADER_MAKER // 2 Byte maker code
	.zero 2 - (. - h_maker_code)
h_required:
	.byte 0x96 // Mandatory, that's it
h_unit_code:
	.byte 0x00 // Hardware model ?
h_device:
	.byte 0x00
h_reserved:
	.zero 7
h_version:
	.byte 0x00
h_checksum:
	.byte 0x00 // Header checksum. To patch later !
h_rom_checksum:
	.zero 2 // Whole ROM checksum. Safely ignorable ? To patch later !
h_multiboot_startup:
	.zero 4 // Startup when booting in multiboot mode, as opposed to regular cartridge boot.
hb_boot_mode:
	.zero 1 // Overwritten by bios
hb_slave_id:
	.zero 1 // Overwritten by bios
hb_reserved:
	.zero 26
hb_jobus_startup:
	.zero 4 // Startup when booting in joybus mode.

// MOSTLY TAKEN FROM HERE: https://github.com/georgemorgan/gba/blob/master/gba.s

.section ".text"
.equ REGBASE, 0x4000000
.equ DISPCNT, 0x4000000
.equ VRAM_ADDR, 0x6000000

startup:
	mov r0, #REGBASE
	str r0, [r0, #0x208]
	/* Put the ARM processor into IRQ mode. */
	mov r0, #0x12
	msr cpsr, r0 // Set coprocessor register ?  ?
	/* Set up the IRQ stack. Defined in linker script. */
	ldr	sp, =IRQ_STACK_POINTER
	/* Put the ARM processor into System mode. */
	mov r0, #0x1F
	msr cpsr, r0
	/* Set up the user stack. Defined in linker script. */
	ldr	sp, =USER_STACK_POINTER
	bl main
