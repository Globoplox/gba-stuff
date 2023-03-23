BUILD			:= ./build
GENERATED	:= ./generated
ASSETS		:= ./assets
SRC				:= ./src
TARGET		:= $(BUILD)/main.gba

GCC				:= arm-none-eabi-gcc
OBJCOPY		:= arm-none-eabi-objcopy
CRYSTAL		:= crystal
LLC				:= llc
OPT				:= opt
MGBA			:= mgba-qt
CAT				:= cat
MKDIR			:= mkdir
MV				:= mv
RM				:= rm
LS				:= ls
CP				:= cp
SHARDS		:= shards

HEADER_DEFINES	:= -DHEADER_TITLE='"Test"' -DHEADER_MAKER='"GX"' -DHEADER_CODE='"ATSE"'

ASSETS_TILESET_SOURCES := $(wildcard $(ASSETS)/*.bmp)
ASSETS_TILESET_BIN := $(patsubst $(ASSETS)/%.bmp,$(BUILD)/%.tileset.bin,$(ASSETS_TILESET_SOURCES))
ASSETS_PALETTE_BIN := $(patsubst $(ASSETS)/%.bmp,$(BUILD)/%.palette.bin,$(ASSETS_TILESET_SOURCES))
ASSETS_TILESET_OBJECTS := $(patsubst %.tileset.bin,%.tileset.o,$(ASSETS_TILESET_BIN))
ASSETS_PALETTE_OBJECTS := $(patsubst %.palette.bin,%.palette.o,$(ASSETS_PALETTE_BIN))
ASSETS_OBJECTS := $(ASSETS_TILESET_OBJECTS) $(ASSETS_PALETTE_OBJECTS)

$(ASSETS_TILESET_BIN): $(BUILD)/%.tileset.bin : $(ASSETS)/%.bmp
	$(SHARDS) run bmp_to_8bpp_tileset -- $< $@

$(ASSETS_TILESET_OBJECTS): $(BUILD)/%.tileset.o : $(BUILD)/%.tileset.bin
	$(OBJCOPY) -I binary -O elf32-littlearm -B arm --rename-section .data=.rodata.tileset.$(basename $(basename $(notdir $@))) $< $@ 

$(ASSETS_PALETTE_BIN): $(BUILD)/%.palette.bin : $(ASSETS)/%.bmp
	$(SHARDS) run bmp_to_palette -- $< $@

$(ASSETS_PALETTE_OBJECTS): $(BUILD)/%.palette.o : $(BUILD)/%.palette.bin
	$(OBJCOPY) -I binary -O elf32-littlearm -B arm --rename-section .data=.rodata.palette.$(basename $(basename $(notdir $@))) $< $@ 

$(BUILD):
	$(MKDIR) -p $@

$(GENERATED):
	$(MKDIR) -p $@

$(BUILD)/startup.o: $(SRC)/startup.S $(BUILD)
	$(GCC) -c -g3 $< $(HEADER_DEFINES) -o $@

$(BUILD)/main.ll: $(SRC)/main.cr $(BUILD)
	$(CRYSTAL) build --error-trace --cross-compile --mcpu arm7tdmi --target arm-none-eabi --prelude=empty --emit=llvm-ir $< -o $(BUILD)/__discard
	$(RM) $(BUILD)/__discard.o
	$(MV) main.ll $(BUILD)

$(BUILD)/main.bc: $(BUILD)/main.ll
	$(CAT) $< | $(OPT) -o $@

$(BUILD)/main.o: $(BUILD)/main.bc
	$(LLC) $< -function-sections -data-sections -filetype=obj -o $@

$(BUILD)/main.elf: $(BUILD)/main.o $(BUILD)/startup.o $(ASSETS_OBJECTS) $(SRC)/gba.ld
	$(GCC) $(BUILD)/main.o $(BUILD)/startup.o -T $(SRC)/gba.ld $(ASSETS_OBJECTS) -Wl,--gc-sections -Wno-warn-execstack -nostdlib -o $@

$(BUILD)/main.gba: $(BUILD)/main.elf
	$(OBJCOPY) -v -O binary $< $@

run: $(BUILD)/main.gba
	$(MGBA) $<

clean:
	-$(MV) $(BUILD)/* /tmp
	-$(MV) $(GENERATED)/* /tmp

.PHONY: run clean
.DEFAULT_GOAL := $(BUILD)/main.gba
