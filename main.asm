; ARMOR DUEL 2600 - Milestone 2.4: charged shot + recoil
; Joystick: up/down drive, left/right hull, fire+left/right turret.
; Hold fire (without turning the turret) for FIRE_HOLD frames to shoot.
; Rotating the turret resets the charge. The tank brightens while charging.
; Firing kicks the tank backwards (recoil) and flashes the background.
;
; NOTA: "processor 6502" DEBE ir con sangria (espacios o tab), nunca en la columna 0.

	processor 6502

    include "include/hardware.inc"
    include "include/variables.inc"
    include "include/constants.inc"
    include "src/reset.asm"
    include "src/frame.asm"
    include "src/graphics.asm"
    include "src/controls.asm"
    include "src/movement.asm"
    include "src/projectile.asm"
    include "src/recoil.asm"
    include "src/bullet.asm"
    include "src/target.asm"
    include "src/directions.asm"
    include "src/position.asm"
    include "src/sprites.asm"
    include "src/vectors.asm"
