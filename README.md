# ARMOR DUEL 2600 — Milestone 2.3.1 (refactor)

Esta versión **no agrega mecánicas**: divide el `main.asm` del usuario en archivos usando `include` de DASM. Se preservan todas las instrucciones, constantes, tablas, comentarios y el **orden de ensamblado** del original. El original se incluye en `original/main.asm` para comparar.

## Compilar (desde la raíz del proyecto)

```sh
dasm main.asm -f3 -oarmor_duel.bin -larmor_duel.lst -sarmor_duel.sym
stella armor_duel.bin
```

Para verificar equivalencia binaria:

```sh
dasm original/main.asm -f3 -ooriginal.bin
dasm main.asm -f3 -orefactor.bin
cmp original.bin refactor.bin
```

`cmp` sin salida y con código 0 indica igualdad byte a byte. El código fue verificado mediante reconstrucción textual exacta, pero **no se ejecutó DASM** en este entorno.

## Organización

- `include/hardware.inc`: registros TIA y RIOT.
- `include/variables.inc`: mapa RAM.
- `include/constants.inc`: parámetros de carga, retroceso y colores.
- `src/reset.asm`: inicialización.
- `src/frame.asm`: VBLANK, composición y preparación de posiciones.
- `src/graphics.asm`: kernel visible y overscan.
- `src/controls.asm`: giro de casco y torreta.
- `src/movement.asm`: conducción, diagonales y límites.
- `src/projectile.asm`: carga y disparo.
- `src/recoil.asm`: retroceso.
- `src/bullet.asm`: actualización del proyectil.
- `src/directions.asm`: vectores de ocho direcciones.
- `src/position.asm`: posicionamiento horizontal.
- `src/sprites.asm`: tablas gráficas.
- `src/vectors.asm`: vectores de arranque.

**Nota:** `include` es inclusión textual, no módulos independientes; se conserva deliberadamente el orden original para mantener las mismas direcciones y saltos. `main.asm` debe ensamblarse desde la raíz para resolver rutas relativas.

## Makefile (macOS / terminal)

Con DASM y Stella instalados (`brew install dasm stella`, si estan disponibles en tu Homebrew):

```sh
make           # genera build/armor_duel.bin, .lst y .sym
make run       # ejecuta la ROM en Stella
make compare   # verifica equivalencia con original/main.asm
make debug     # muestra rutas de los archivos de depuracion
make clean     # borra build/
make help
```

El Makefile recompila cuando cambia `main.asm`, cualquier `src/*.asm` o
`include/*.inc`. Si Stella esta instalada como app y no como comando en PATH,
usa `make run STELLA='open -a Stella'` (macOS). Para cambiar el ejecutable
DASM, usa `make DASM=/ruta/a/dasm`.
