# ARMOR DUEL — Urban Warfare 3.1 (prototipo experimental)

Este hito cambia la silueta de las arenas: dos conjuntos de edificios separados por
un **callejon horizontal**, con colisiones correspondientes para tanques y balas.

## Arenas
- BLOCKADE: bloques amplios y callejon central.
- DEPOT: edificios altos y angostos.
- CROSSROADS: edificios mas separados horizontalmente.

## Alcance y limitaciones
- Mantiene el sistema de votos, combate, rebotes y puntuacion existentes.
- No incorpora aun un kernel asimetrico, rotulos ni cartucho ampliado.
- El callejon central ocupa filas de kernel [42,54); el tanque necesita sus
  ocho filas completamente dentro para pasar por el hueco.
- Se conservan los limites de colision horizontales de la arena elegida.
- **Experimental, sin compilacion ni prueba en Stella**. Guardar la ROM estable
  anterior y probar primero que no aparezca CRT, que ambos tanques atraviesen
  el callejon y que las balas reboten en edificios pero no en el hueco.

## Ejecutar
`make clean && make run`

## Siguiente arquitectura
La representacion actual sigue usando un solo patron PF2 por arena y espejo.
Para edificios verdaderamente variados hace falta geometria por bandas y
colisiones derivadas de los mismos datos; el siguiente paso sera preparar
esa tabla y auditar el kernel de 76 ciclos/scanline antes de agregarla.
