BUILD			:= build
SRC				:= src
TARGET		:= $(BUILD)/main.gba

GCC				:= arm-none-eabi-gcc
OBJCOPY		:= arm-none-eabi-objcopy
CRYSTAL		:= crystal
LLC				:= llc
OPT				:= opt
MGBA			:= mgba
CAT				:= cat
MKDIR			:= mkdir
MV				:= mv
RM				:= rm

HEADER_DEFINES	:= -DHEADER_TITLE='"Test"' -DHEADER_MAKER='"GX"' -DHEADER_CODE='"ATSE"'

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

$(BUILD)/main.elf: $(BUILD)/main.o $(BUILD)/startup.o $(SRC)/gba.ld
	$(GCC) $(BUILD)/main.o $(BUILD)/startup.o -T $(SRC)/gba.ld -Wl,--gc-sections -Wno-warn-execstack -nostdlib -o $@

$(BUILD)/main.gba: $(BUILD)/main.elf
	$(OBJCOPY) -v -O binary $< $@

run: $(BUILD)/main.gba
	$(MGBA) $<

clean:
	-$(MV) $(BUILD)/* /tmp

re: clean 

.PHONY: run clean re
.DEFAULT_GOAL := $(BUILD)/main.gba
