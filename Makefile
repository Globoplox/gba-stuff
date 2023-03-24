BUILD			:= ./build
GENERATED	:= ./generated
ASSETS		:= ./assets
SRC				:= ./src
BIN				:= ./bin
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

ASSETS_MAPS := $(wildcard $(ASSETS)/*.map.bmp)
ASSETS_MAP_OBJECTS := \
	$(patsubst $(ASSETS)/%.map.bmp,$(BUILD)/%.map.o,$(ASSETS_MAPS)) \
	$(patsubst $(ASSETS)/%.map.bmp,$(BUILD)/%.set.o,$(ASSETS_MAPS)) \
	$(patsubst $(ASSETS)/%.map.bmp,$(BUILD)/%.pal.o,$(ASSETS_MAPS))
# ASSETS_SETS := $(wildcard $(ASSETS)/*.set.bmp)
# ASSETS_SET_OBJECTS := \
# 	$(patsubst %.set.bmp,%.set.o,$(ASSETS_MAPS)) \
# 	$(patsubst %.set.bmp,%.pal.o,$(ASSETS_MAPS))
# ASSETS_PALS := $(wildcard $(ASSETS)/*.pal.bmp)
# ASSETS_PAL_OBJECTS := \
# 	$(patsubst %.pal.bmp,%.pal.o,$(ASSETS_MAPS))

ASSETS_OBJECTS := \
	$(ASSETS_MAP_OBJECTS) \
#	$(ASSETS_SET_OBJECTS)
#	$(ASSETS_PAL_OBJECTS)

$(BIN)/bmp_to_assets : src/compile_time/bmp_to_assets.cr
	$(SHARDS) build bmp_to_assets

$(BUILD)/%.map.bin $(BUILD)/%.set.bin $(BUILD)/%.pal.bin &: $(ASSETS)/%.map.bmp $(BUILD) $(BIN)/bmp_to_assets
	$(BIN)/bmp_to_assets $(ASSETS)/$*.map.bmp $(BUILD)/$*.map.bin $(BUILD)/$*.set.bin $(BUILD)/$*.pal.bin

$(BUILD)/%.set.o: $(BUILD)/%.set.bin
	$(OBJCOPY) -I binary -O elf32-littlearm -B arm --rename-section .data=.rodata.set.$* $< $@

$(BUILD)/%.pal.o: $(BUILD)/%.pal.bin
	$(OBJCOPY) -I binary -O elf32-littlearm -B arm --rename-section .data=.rodata.pal.$* $< $@

$(BUILD)/%.map.o: $(BUILD)/%.map.bin
	$(OBJCOPY) -I binary -O elf32-littlearm -B arm --rename-section .data=.rodata.map.$* $< $@

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
