; --- Ajustes de sensacion (cambia estos valores a tu gusto) ---
FIRE_HOLD     = 180    ; frames para cargar el disparo (180 = 3 s a 60 Hz)
RECOIL_LEN    = 14     ; frames de retroceso
RECOIL_FAST   = 9      ; mientras RecoilFrames >= esto, 2 px por frame (patada fuerte); luego 1 px
LOCK_FRAMES   = 60     ; frames sin poder moverse ni girar tras disparar (60 = 1 s)
BULLET_SPEED  = 4      ; px por frame de la bala (antes 1 px cada 3 frames)
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
WALL_COLOR      = $0C    ; gris: lo comparten muros y bala (la bala es el Ball, usa COLUPF)
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
CWALL_Y0    = 32
CWALL_Y1    = 64
CWALL_TANK_X_LO = CWALL_X0 + P0_OFFSET - SPRITE_W + 1
CWALL_TANK_X_HI = CWALL_X1 + P0_OFFSET
CWALL_TANK_Y_LO = CWALL_Y0 - SPRITE_W + 1
CWALL_TANK_Y_HI = CWALL_Y1
CWALL_BUL_X_LO  = CWALL_X0 + M0_OFFSET
CWALL_BUL_X_HI  = CWALL_X1 + M0_OFFSET
CWALL_BUL_Y_LO  = CWALL_Y0 - 1
CWALL_BUL_Y_HI  = CWALL_Y1

; --- Vertical: kernel REAL de 2 scanlines por fila (96 filas = 192 lineas) ---
; 1 unidad de Y = 2 scanlines. Antes cada fila tardaba ~83 ciclos (>76) y el
; kernel se salia a 2 lineas sin querer (frame de ~450 lineas).
KERNEL_ROWS     = 96
WALL_TOP_ROWS   = 4                      ; fila 1 muro, filas 2..3 marcador, fila 4 muro
WALL_BOT_START  = KERNEL_ROWS - 2        ; muro inferior: filas 95..96
; La fila donde cambia el playfield (3 arriba, 95 abajo) debe quedar libre de
; sprites/bala para que el cambio de PF no corrompa GRP/ENABL.
TANK_MIN_Y      = 5
TANK_MAX_Y      = 86                     ; exclusivo (maximo 85)
BULLET_MIN_Y    = 5
BULLET_MAX_Y    = 93                     ; exclusivo (maximo 92)
START_Y         = 44

; --- Carga: el tanque frena mientras se mantiene Fire ---
STOP_FRAMES     = 30                     ; 0.5 s totalmente quieto antes de disparar
STOP_AT         = FIRE_HOLD - STOP_FRAMES

; --- Rebotes de bala ---
BOUNCES   = 2    ; rebotes por bala. 0 = sin rebotes (la bala muere al tocar un muro)
SELF_HIT  = 1    ; 1 = tras rebotar, la bala tambien puede golpear a quien disparo. 0 = nunca

; --- Partida (2.7) ---
WIN_SCORE      = 5     ; puntos para ganar la partida (maximo 8: el marcador tiene 8 casillas)
ROUND_PAUSE    = 90    ; frames de pausa tras cada punto (90 = 1.5 s)
VICTORY_PAUSE  = 240   ; frames de pantalla de victoria (4 s)
HUD_P1_COLOR   = $88   ; color de las casillas del J1 y del destello si gana el J1
HIDDEN_Y       = 200   ; Y fuera de pantalla para el tanque destruido
HUD_DIM_COLOR  = WALL_COLOR   ; casillas vacias y divisor: mismo gris que los muros
HUD_B_WALLS    = 1             ; 1 = el muro lateral de la fila de color toma el color del jugador; 0 = sin muro ahi
