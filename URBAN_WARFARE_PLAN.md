# ARMOR DUEL — Urban Warfare: rediseño propuesto

## Cambio incluido en esta entrega
`HUD_B_WALLS = 0`: elimina las secciones de muros laterales coloreadas con el marcador en la fila HUD. Mantiene las paredes físicas grises y las colisiones actuales.

## Pendiente (NO implementado)
- Kernel de arenas de varias bandas verticales, en vez de una sola franja PF2.
- Datos de mapa compactos con segmentos por bandas y simetría opcional.
- Colisiones por segmentos que coincidan con los bloques dibujados.
- Tres mapas realmente diferentes: BLOCKADE, INDUSTRIAL y CROSSFIRE.
- Pantalla de selección con instrucciones legibles, por ejemplo LEFT/RIGHT: MAP y FIRE: LOCK. El TIA no dibuja texto automáticamente: hace falta un kernel de caracteres dedicado, posiblemente una pantalla separada.
- Auditoría de ciclos por scanline, ROM libre y RAM disponible.

No se ha compilado ni probado en Stella en este entorno.
