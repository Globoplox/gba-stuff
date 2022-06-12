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
SOURCES		:= src
PREFIX		:= arm-none-eabi
CC		:= $(PREFIX)-gcc
LD		:= $(PREFIX)-gcc
OBJCOPY		:= $(PREFIX)-objcopy
STRIP		:= $(PREFIX)-strip
ARCH		:= -mthumb -mthumb-interwork
LINKER_SCRIPT	:= gba.ld
CFLAGS		:= $(DEFINES) $(ARCH) -mcpu=arm7tdmi -O -fomit-frame-pointer -ffast-math -fno-strict-aliasing -Wall -I$(SOURCES)/
ASFLAGS		:= $(ARCH) $(DEFINES)
LDFLAGS		:= $(ARCH) -T $(LINKER_SCRIPT) -nostartfiles --specs=nosys.specs -ffreestanding
OBJECTS_C	:= $(patsubst %.c, %.o, $(wildcard $(SOURCES)/*.c))
# Case is meaningful: .S files are preprocessed, .s are not. 
OBJECTS_A	:= $(patsubst %.S, %.o, $(wildcard $(SOURCES)/*.S))

.PHONY: build clean

build: $(TARGET).gba

$(TARGET).gba: $(TARGET).elf
	$(OBJCOPY) -v -O binary $< $@

$(TARGET).elf: $(LINKER_SCRIPT) $(OBJECTS_C) $(OBJECTS_A) 
	$(LD) $(filter-out $<, $^) $(LDFLAGS) -o $@

$(OBJECTS_C): %.o : %.c
	$(CC) -c $< $(CFLAGS) -o $@

$(OBJECTS_A): %.o : %.S
	$(CC) -c $< $(ASFLAGS) -o $@

clean:
	rm -f $(OBJECTS_A) $(OBJECTS_C) $(TARGET).elf $(TARGET).gba
