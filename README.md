# ARMOR DUEL 2600 — Milestone 1.1

Changes from Milestone 1:
- Drive movement every 3 frames instead of every frame.
- Diagonal movement alternates horizontal and vertical pixel steps, reducing diagonal speed and avoiding simultaneous X/Y jumps.
- Turning remains one 45-degree step every 6 frames.

Build on macOS:

```sh
dasm main.asm -f3 -oarmor_duel.bin
stella armor_duel.bin
```

Not yet verified with a local DASM executable. If horizontal snapping remains, investigate the TIA RESP0/HMP0 positioning routine separately. This version deliberately does not add acceleration or friction yet.
