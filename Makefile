# PANZER 2600 - build con DASM + Stella
DASM   ?= dasm
STELLA ?= stella
BUILD  := build
ROM    := $(BUILD)/panzer2600.bin
LIST   := $(BUILD)/panzer2600.lst
SYMS   := $(BUILD)/panzer2600.sym
ORIG   := $(BUILD)/original.bin
SOURCES := main.asm $(wildcard src/*.asm) $(wildcard include/*.inc)

.DEFAULT_GOAL := all
.PHONY: maps all run debug timing compare clean help

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

timing: $(ROM)
	@echo "=== PANZER: prueba de sincronizacion ==="
	@echo "1. Abrir Stella con: make run"
	@echo "2. Abrir debugger de Stella (tecla de acceso al debugger o menu Debugger, segun configuracion)."
	@echo "3. Consultar scanlines/frame y cycles/scanline en el debugger."
	@echo "4. Probar quieto, cargando, disparando y al impactar."
	@echo "5. Ver TIMING_TEST.md para interpretar resultados."

compare: $(ROM) $(ORIG)
	@echo "NOTA: el original es 2.3 y la ROM actual es 2.4.2; es normal que sean diferentes."
	@if cmp -s $(ROM) $(ORIG); then echo "ROMs iguales (inesperado para 2.4.2)"; else echo "ROMs distintas: esperado."; fi

clean:
	rm -rf $(BUILD)

help:
	@echo "make          - Compilar ROM"
	@echo "make run      - Compilar y abrir Stella"
	@echo "make debug    - Generar/ver rutas de ROM, listado y simbolos"
	@echo "make timing   - Guia de prueba de scanlines en Stella"
	@echo "make compare  - Comparar ROM modular con original"
	@echo "make clean    - Limpiar build/"
	@echo "make help     - Mostrar esta ayuda"

maps:
	python3 tools/genmaps.py
