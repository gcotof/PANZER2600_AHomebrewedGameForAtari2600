; --- Ajustes de sensacion (cambia estos valores a tu gusto) ---
FIRE_HOLD     = 180    ; frames para cargar el disparo (180 = 3 s a 60 Hz)
RECOIL_LEN    = 5      ; frames de retroceso, 1 px por frame (= 5 px)
FLASH_LEN     = 2      ; frames de destello al disparar
BG_COLOR      = $22
FLASH_COLOR   = $2E


TARGET_RESPAWN_FRAMES = 45
TARGET_COLOR = $3A

; --- Barreras: coordenadas medidas en Stella ---
; El playfield tiene 40 pixeles de 4 px (20 por mitad). Con CTRLPF bit0=1
; (PF_MIRROR) la mitad derecha es el REFLEJO de la izquierda, asi que
; PF0=$10 dibuja la barrera en x=0..3 (izquierda) y x=156..159 (derecha).
; x=0 es el primer pixel visible; la pantalla visible mide 160 px.
PF_MIRROR       = $01
WALL_PF0        = $10
WALL_COLOR      = $46
WALL_LEFT_EDGE  = 4      ; primer pixel libre a la derecha de la barrera izquierda
WALL_RIGHT_EDGE = 156    ; primer pixel de la barrera derecha

; Con SetHorizPos, un objeto en la coordenada X se dibuja en pantalla en:
;   Player (sprite de 8 px): pantalla = X - 15   (ocupa X-15 .. X-8)
;   Missile (1 px):          pantalla = X - 16
P0_OFFSET       = 15
M0_OFFSET       = 16
SPRITE_W        = 8

; Limites del tanque (origen X): el sprite de 8 px queda entre las barreras.
TANK_MIN_X      = WALL_LEFT_EDGE + P0_OFFSET                  ; 19
TANK_MAX_X      = WALL_RIGHT_EDGE + P0_OFFSET - SPRITE_W + 1  ; 164 (exclusivo; maximo 163)

; Limites de la bala (origen X): muere al tocar la barrera.
BULLET_MIN_X    = WALL_LEFT_EDGE + M0_OFFSET    ; 20: por debajo toca x<=3
BULLET_MAX_X    = WALL_RIGHT_EDGE + M0_OFFSET   ; 172: desde aqui toca x>=156
TANK2_COLOR = $C8

CWALL_PF2   = $C0
CWALL_X0    = 72
CWALL_X1    = 88
CWALL_Y0    = 80
CWALL_Y1    = 112
CWALL_TANK_X_LO = CWALL_X0 + P0_OFFSET - SPRITE_W + 1
CWALL_TANK_X_HI = CWALL_X1 + P0_OFFSET
CWALL_TANK_Y_LO = CWALL_Y0 - SPRITE_W + 1
CWALL_TANK_Y_HI = CWALL_Y1
CWALL_BUL_X_LO  = CWALL_X0 + M0_OFFSET
CWALL_BUL_X_HI  = CWALL_X1 + M0_OFFSET
CWALL_BUL_Y_LO  = CWALL_Y0 - 1
CWALL_BUL_Y_HI  = CWALL_Y1
