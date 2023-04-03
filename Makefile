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

ASSETS_FILE = $(ASSETS)/assets.yaml

$(BIN)/assets_builder: src/compile_time/assets.cr
	$(SHARDS) build assets_builder

$(BUILD)/assets.o: $(ASSETS_FILE) | $(BIN)/assets_builder $(BUILD)
	$(BIN)/assets_builder -f $< -o $@

$(BUILD):
	$(MKDIR) -p $@

$(BUILD)/startup.o: $(SRC)/startup.S | $(BUILD)
	$(GCC) -c -g3 $< $(HEADER_DEFINES) -o $@

$(BUILD)/main.ll: $(SRC)/main.cr | $(BUILD)
	$(CRYSTAL) build --error-trace --cross-compile --mcpu arm7tdmi --target arm-none-eabi --prelude=empty --emit=llvm-ir $< -o $(BUILD)/__discard
	$(RM) $(BUILD)/__discard.o
	$(MV) main.ll $(BUILD)

$(BUILD)/main.bc: $(BUILD)/main.ll
	$(CAT) $< | $(OPT) -o $@

$(BUILD)/main.o: $(BUILD)/main.bc
	$(LLC) $< -function-sections -data-sections -filetype=obj -o $@

$(BUILD)/main.elf: $(BUILD)/main.o $(BUILD)/startup.o $(BUILD)/assets.o $(SRC)/gba.ld
	$(GCC) $(BUILD)/main.o $(BUILD)/startup.o -T $(SRC)/gba.ld $(BUILD)/assets.o -Wl,--gc-sections -Wno-warn-execstack -nostdlib -o $@

$(BUILD)/main.gba: $(BUILD)/main.elf
	$(OBJCOPY) -v -O binary $< $@

run: $(BUILD)/main.gba
	$(MGBA) $<

clean:
	[ -d $(BUILD) ] && $(MV) $(BUILD)/* /tmp 2> /dev/null || true
	[ -d $(GENERATED) ] && $(MV) $(GENERATED)/* /tmp 2> /dev/null || true
	[ -d $(BIN) ] && $(MV) $(BIN)/* /tmp 2> /dev/null || true

.PHONY: run clean
.DEFAULT_GOAL := $(BUILD)/main.gba
