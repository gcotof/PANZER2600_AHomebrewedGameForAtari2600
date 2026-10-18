# untitledTankGame 2600 — Milestone 0 (smoke test)

macOS (Apple Silicon or Intel):

```sh
brew install dasm stella
cd armor-duel-2600
dasm main.asm -f3 -oarmor_duel.bin
stella armor_duel.bin
```

This is an intentionally minimal 4 KiB Atari 2600 ROM source. It displays an 8-pixel-wide tank placeholder and reads the left joystick. Up/down moves the placeholder vertically; left/right updates an internal Facing byte but does not yet affect movement or visuals. No turret, firing, two-button input, or coprocessor support yet. This is a hardware/graphics smoke test, not a playable tank game.

Next: implement eight-direction fixed-point movement and independent turret state, then investigate display kernels and enhanced cartridges. Stella compatibility does not imply Atari 2600+ compatibility.
