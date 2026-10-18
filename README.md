# ARMOR DUEL 2600 — Milestone 1.2

## Objetivo
Ocho orientaciones visuales del casco (8×8) sin cambiar la física ni los controles del Milestone 1.1.

## Compilar en macOS
```sh
dasm main.asm -f3 -oarmor_duel.bin
stella armor_duel.bin
```

## Controles
- Izquierda/derecha: girar el casco 45 grados cada seis cuadros.
- Arriba: avanzar según Facing.
- Abajo: retroceder según Facing.

## Cómo funciona
`SpriteBase = Facing * 8` se calcula una vez por cuadro.
En cada línea visible, se calcula `Row - TankY`. Si está entre 0 y 7,
se suma `SpriteBase` y se lee un byte de `TankSprites`.
Cada orientación ocupa ocho bytes consecutivos de ROM.

## Importante
Se conservó **literalmente** la rutina `PositionPlayer` aportada por el usuario,
con `SEC` fuera del bucle y escritura `RESP0` antes de `HMP0`.
No se cambió la velocidad, el control de diagonales ni los límites.

## Pendiente
- Estas siluetas son provisionales, no sprites definitivos de tanques.
- La torreta independiente se desarrollará en el Milestone 2.
- Verificar en Stella el aspecto y el timing antes de optimizar.
