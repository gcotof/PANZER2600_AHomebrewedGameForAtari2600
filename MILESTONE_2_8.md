# Milestone 2.8 — Competitive Arena System

| Ítem | Dónde |
|---|---|
| 2.8.1 Infraestructura de arenas | `src/arena.asm` (`ArenaTable`, `LoadArena`). El kernel (`graphics.asm`) y las colisiones (`wall.asm`, `movement.asm`) leen la arena desde RAM (`ArenaY0/Y1/PF2`, límites `AT*`/`AB*`). |
| 2.8.2 Tres arenas | 0 pilar central (original), 1 dos bloques anchos, 2 dos muros altos. Obstáculo izquierdo + espejo derecho ⇒ simétricas. Para añadir otra: una línea en `ArenaTable` y subir `ARENA_COUNT`. |
| 2.8.3 Votación independiente | J1/J2 mueven izquierda/derecha para elegir (1–3); botón = confirmar (voto bloqueado). |
| 2.8.4 Unanimidad / desempate | Mismo voto ⇒ esa arena. Distinto ⇒ 50/50 por paridad de un contador de frames al confirmar el segundo. |
| 2.8.5 Pantalla de selección | Sin tanques; se ve la arena votada (gris = acuerdo; azul/verde alternando = voto de J1/J2). Pips del marcador = nº de arena de cada jugador: parpadean sin confirmar, fijos confirmados. |
| 2.8.6 Arena fija en la partida | `ArenaSel` solo cambia en la selección (inicio y tras la victoria). |
| 2.8.7 Geometría por ronda | `StartRound` recarga `ArenaSel` con `LoadArena`. |

Cambio extra: `P2_START_X = 126` (antes 120) para que el spawn del J2 sea el espejo exacto del J1 (`P1_START_X = 56`).
RAM nueva: `$E4..$F7` (la pila queda con 8 bytes en `$F8..$FF`; no añadir más variables sin revisarlo).
No verificado en Stella: solo se comprobó que ensambla con DASM.
