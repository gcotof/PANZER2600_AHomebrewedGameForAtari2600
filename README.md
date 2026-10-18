# ARMOR DUEL 2600 - Milestone 2.1

Adds one independently moving projectile using TIA Missile 0 (`RESM0`, `HMM0`, `ENAM0`).

## Controls
- Up / Down: forward / reverse relative to hull
- Left / Right: rotate hull
- Fire + Left / Right: rotate turret
- Tap Fire without Left / Right: launch one projectile (only one active at once)

## Build
```sh
dasm main.asm -f3 -oarmor_duel.bin
stella armor_duel.bin
```

## Notes
- The projectile starts near the center of the tank and moves in the turret direction.
- No collisions yet. Bullet disappears at the arena boundary.
- The projectile moves every three frames; diagonal projectiles are currently faster than cardinal projectiles.
- The hardware projectile shares the player's color (`COLUP0`).
- This version is not yet compiled or tested with DASM/Stella in the authoring environment.
