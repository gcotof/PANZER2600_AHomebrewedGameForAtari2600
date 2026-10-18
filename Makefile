# ARMOR DUEL 2600 - build con DASM + Stella
DASM   ?= dasm
STELLA ?= stella
BUILD  := build
ROM    := $(BUILD)/armor_duel.bin
LIST   := $(BUILD)/armor_duel.lst
SYMS   := $(BUILD)/armor_duel.sym
ORIG   := $(BUILD)/original.bin
SOURCES := main.asm $(wildcard src/*.asm) $(wildcard include/*.inc)

.DEFAULT_GOAL := all
.PHONY: all run debug compare clean help

all: $(ROM)

$(BUILD):
	mkdir -p $(BUILD)

$(ROM): $(SOURCES) | $(BUILD)
	$(DASM) main.asm -f3 -o$(ROM) -l$(LIST) -s$(SYMS)

run: $(ROM)
	$(STELLA) $(ROM)

debug: $(ROM)
	@echo "ROM: $(ROM)"
	@echo "Listado: $(LIST)"
	@echo "Simbolos: $(SYMS)"
	@echo "Abri la ROM en el depurador de Stella para usar los simbolos."

$(ORIG): original/main.asm | $(BUILD)
	$(DASM) original/main.asm -f3 -o$(ORIG)

compare: $(ROM) $(ORIG)
	cmp $(ROM) $(ORIG)
	@echo "ROMs identicas byte por byte."

clean:
	rm -rf $(BUILD)

help:
	@echo "make          - Compilar ROM"
	@echo "make run      - Compilar y abrir Stella"
	@echo "make debug    - Generar/ver rutas de ROM, listado y simbolos"
	@echo "make compare  - Comparar ROM modular con original"
	@echo "make clean    - Limpiar build/"
	@echo "make help     - Mostrar esta ayuda"
