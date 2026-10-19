# Milestone 2.5B.1 — Arena a pantalla completa (playfield espejado)

Paso 1 de 2.5B (paredes rodeables). Solo cambia el area de juego; no hay
mecanicas nuevas.

## Que estaba pasando
Con `CTRLPF=0` el playfield se REPITE cada 80 px. La barrera "derecha"
quedaba en x=80..83 (mitad de pantalla) y el tanque solo podia usar x=4..79.

## Cambio
`CTRLPF=1` (bit 0 = REFLECT): la mitad derecha del playfield es el reflejo
de la izquierda. Con el mismo `PF0=$10`, las barreras quedan en x=0..3 y
x=156..159, y el area de juego mide 152 px (x=4..155).

## Archivos
- `src/reset.asm`: se escribe `CTRLPF = PF_MIRROR` (antes se ponia a 0).
- `include/constants.inc`: `PF_MIRROR`, `WALL_RIGHT_EDGE = 156`. Los limites se
  recalculan solos:
  | Objeto | Limite izq | Limite der |
  |--------|-----------|------------|
  | Tanque (`TankX`) | 19 | 163 |
  | Bala (`BulletX`) | muere con < 20 | muere con >= 172 |
- `src/bullet.asm`: la guarda anti-wrap pasa de 156 a 200. Con 156 la bala
  moriria a mitad de pantalla (x=140).
- `src/wall.asm`: solo comentarios.

## Verificado en emulador (Stella)
- Barreras en pantalla: x=0..3 y x=156..159.
- Posicion lineal en todo el ancho: tanque en pantalla = `TankX-15..-8`,
  bala = `BulletX-16`, medidos de TankX 19..163 y BulletX 20..171.
- Tanque hacia el este: se detiene en TankX=163 (pixeles hasta x=154).
- Tanque hacia el oeste: se detiene en TankX=19 (pixeles desde x=5).
- Bala hacia la derecha: ultimo pixel x=155. Hacia la izquierda: x=4.

## Pendiente de esta etapa
El blanco sigue en x=64 y x=32 (mitad izquierda). Se reubica cuando
tengamos las paredes.
