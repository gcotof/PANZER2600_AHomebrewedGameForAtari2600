# ARMOR DUEL 3.3: casco 8, torreta 16

Se parte de 3.2 (NO del experimento 3.2.1/3.2.2).

- Casco P1/P2: Facing y Facing2 solo 0..7; rotacion con AND #7.
- Movimiento original 8 direcciones: HullDeltaX/Y; alternancia diagonal original.
- Sprite del casco: indice Facing*8 (sin LSR).
- Torreta P1/P2: TurretFacing/Turret2Facing 0..15, 16 sprites.
- Disparos y retroceso: vectores de 16 direcciones, sin tocar.
- Tanque P2 inicia mirando al oeste: Facing2=6; torreta=12.

Compilar: make clean && make run
Pruebas: rotar casco 8 pasos, torreta 16; acelerar N con torreta NNE;
reversa, P2, rebotes y transiciones de ronda.

Nota: no compilado ni ejecutado en Stella en este entorno.
