# ARMOR DUEL 3.1.2 — Arena iteration (experimental)

This is a **small intermediate iteration**, NOT the promised fully data-driven urban map engine.

- Arena parameters have been rebalanced for wider BLOCKADE, narrower DEPOT and a compact CROSSROADS. Existing symmetric playfield renderer and collision logic are retained.
- HUD_B_WALLS is restored to 1 to avoid the empty slots at the outer ends of the score row. This restores the colored end segments too; a proper neutral-color HUD needs a new raster schedule.
- No bank switching or custom cartridge changes yet.
- Not compiled or tested in Stella in this environment.

To test: `make clean && make run`.

## Next architectural step
Implement multiple PF0/PF1/PF2 bands and derive collision rectangles from the same map data. Budget kernel cycles before adding graphics, and keep the current ROM as fallback.
