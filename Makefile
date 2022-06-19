# 0-12 Byte Title
TITLE		:= "Test"
# 4 Byte ID
CODE		:= "ATSE"
# 2 Byte maker
MAKER_CODE	:= "GX"
DEFINES		+= -DHEADER_TITLE=\"$(TITLE)\"
DEFINES		+= -DHEADER_CODE=\"$(CODE)\"
DEFINES		+= -DHEADER_MAKER=\"$(MAKER_CODE)\"
TARGET		:= test
ASSETMGR	:= ./assetmgr
SOURCES		:= src
PREFIX		:= arm-none-eabi
CC		:= $(PREFIX)-gcc
LD		:= $(PREFIX)-gcc
OBJCOPY		:= $(PREFIX)-objcopy
STRIP		:= $(PREFIX)-strip
ARCH		:= -mthumb -mthumb-interwork
LINKER_SCRIPT	:= src/gba.ld
CFLAGS		:= $(DEFINES) $(ARCH) -mcpu=arm7tdmi -fomit-frame-pointer -ffast-math -fno-strict-aliasing -Wall -I$(SOURCES)/
ASFLAGS		:= $(ARCH) $(DEFINES)
LDFLAGS		:= $(ARCH) -T $(LINKER_SCRIPT) -nostartfiles --specs=nosys.specs -ffreestanding
OBJECTS_C	:= $(patsubst %.c, %.o, $(wildcard $(SOURCES)/*.c))
TILESETS	:= $(patsubst %.bmp, %.tileset.bin, $(wildcard $(SOURCES)/*.bmp))
PALETTES	:= $(patsubst %.bmp, %.palette.bin, $(wildcard $(SOURCES)/*.bmp))
OBJECTS_TILESET	:= $(patsubst %.bmp, %.tileset.o, $(wildcard $(SOURCES)/*.bmp))
OBJECTS_PALETTE	:= $(patsubst %.bmp, %.palette.o, $(wildcard $(SOURCES)/*.bmp))
# Case is meaningful: .S files are preprocessed, .s are not. 
OBJECTS_A	:= $(patsubst %.S, %.o, $(wildcard $(SOURCES)/*.S))

all: $(ASSETMGR) $(TARGET).gba

# A tool written in crystal I use to manipulate bmp.
$(ASSETMGR):
	crystal build tools/$(ASSETMGR).cr -o $(ASSETMGR)

$(TARGET).gba: $(TARGET).elf
	$(OBJCOPY) -v -O binary $< $@

$(TARGET).elf: $(LINKER_SCRIPT) $(OBJECTS_C) $(OBJECTS_A) $(OBJECTS_TILESET) $(OBJECTS_PALETTE)
	$(LD) $(filter-out $<, $^) $(LDFLAGS) -o $@

# TODO: Batch all asset processing so ordering make sense

# Extract the raw tileset data
$(TILESETS): %.tileset.bin : %.bmp
	$(ASSETMGR) tileset $< -o $@

# Extract the raw palette data
$(PALETTES): %.palette.bin : %.bmp
	$(ASSETMGR) palette $< -o $@

# Build an object file with the raw tileset data for linking
$(OBJECTS_TILESET): %.tileset.o : %.tileset.bin
	arm-none-eabi-objcopy -I binary -O elf32-littlearm -B arm --rename-section .data=.tileset.$$(basename $< .tileset.bin) $< $@

# Build an object with the raw palette data for linking
$(OBJECTS_PALETTE): %.palette.o : %.palette.bin
	arm-none-eabi-objcopy -I binary -O elf32-littlearm -B arm --rename-section .data=.palette.$$(basename $< .palette.bin) $< $@

$(OBJECTS_C): %.o : %.c
	$(CC) -c $< $(CFLAGS) -o $@

$(OBJECTS_A): %.o : %.S
	$(CC) -c $< $(ASFLAGS) -o $@

fclean: clean
	rm -f $(ASSETMGR)

clean:
	rm -f $(OBJECTS_A) $(OBJECTS_C) $(OBJECTS_TILESET) $(OBJECTS_PALETTE) $(TILESETS) $(PALETTES) $(TARGET).elf $(TARGET).gba

.PHONY: all clean fclean
