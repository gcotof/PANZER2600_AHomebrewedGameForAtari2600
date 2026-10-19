# ARMOR DUEL 3.2 — 16 orientaciones (EXPERIMENTAL)

- Ambos tanques y torretas giran en 16 pasos de 22.5 grados.
- 16 siluetas de torreta (8 originales + 8 intermedias).
- El casco conserva 8 siluetas visuales; cada par de direcciones comparte dibujo, pero cambia su movimiento.
- La bala usa vectores con magnitudes 1/2: cada eje se mueve 0, 2 o 4 px por frame. **ATENCION**: esta version usa 2/4 px por eje, con la velocidad maxima anterior; verificar rebotes y tunneling.
- El recoil conserva desplazamiento de 1 px por eje y las reglas existentes.
- No se modifico el motor de arenas en esta entrega. Se incluye una explicacion tecnica abajo.

## Arenas actuales y Combat

El kernel actual escribe PF2 con un solo patron por arena, y apaga PF2 en STREET_Y0..STREET_Y1. PF0/PF1 siguen reservados a bordes/HUD. Como CTRLPF esta en modo espejo, toda la geometria queda reflejada horizontalmente.

Para mapas estilo Combat: usar bandas verticales (start_row, PF0, PF1, PF2) y construir la colision a partir de las mismas bandas. El TIA permite cambiar playfield en distintas scanlines, pero 76 ciclos por scanline y los 128 bytes RAM siguen siendo el cuello de botella. El banco ROM adicional aporta mapas/codigo, no mas ciclos.

## Verificacion

`make clean && make run`. Probar giros completos, ocho angulos intermedios, rebotes diagonales, recoil y colisiones de esquina. **No compilado ni ejecutado en Stella en este entorno**.
