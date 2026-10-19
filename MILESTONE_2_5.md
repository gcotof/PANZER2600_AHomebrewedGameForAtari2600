# Milestone 2.5A.4 — Barreras corregidas (medidas en Stella)

## Qué estaba mal
La 2.5A.3 asumía las barreras en x=12..15 y x=92..95. Medido en pantalla,
`PF0=$10` con `CTRLPF=0` las dibuja en **x=0..3** y **x=80..83**
(x=0 es el primer pixel visible). Con los limites anteriores:

- Derecha: tanque (max 84) y bala (muerte en 92) se detenian ~4 px antes.
- Izquierda: tanque (min 16) se metia 3 px en la barrera, y la bala
  (muerte en 15) la cruzaba entera.

## Mapeo medido (SetHorizPos)
- Player (sprite de 8 px): pantalla = `X - 15` (ocupa `X-15 .. X-8`)
- Missile (1 px): pantalla = `X - 16`

## Limites nuevos (derivados en `include/constants.inc`)
| Objeto | Condicion | Valor |
|--------|-----------|-------|
| Tanque | `TankX` entre | 19 y 87 |
| Bala hacia la izquierda | muere con `BulletX <` | 20 |
| Bala hacia la derecha | muere con `BulletX >=` | 96 |

Si cambias las barreras (otro `PF0`, otro ancho), ajusta solo
`WALL_LEFT_EDGE` y `WALL_RIGHT_EDGE`; el resto se recalcula.

## Verificacion (emulador Stella, ROM ensamblada con DASM)
- Tanque al este: `TankX=87`, pixeles en x=73..78 (barrera desde 80).
- Tanque al oeste: `TankX=19`, pixeles en x=5..10 (barrera hasta 3).
- Bala derecha: ultimo pixel visible x=79, desaparece en la barrera.
- Bala izquierda: ultimo pixel visible x=4, desaparece en la barrera.

`UpdateWall` sigue comprobando antes de reposicionar el misil, asi que
nunca se coloca por debajo de X=16 (donde el posicionamiento TIA hace wrap).
