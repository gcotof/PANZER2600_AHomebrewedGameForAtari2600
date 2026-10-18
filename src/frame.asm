Frame:
    lda #2
    sta VBLANK
    sta VSYNC
    sta WSYNC
    sta WSYNC
    sta WSYNC
    lda #0
    sta VSYNC
    lda #43
    sta TIM64T

    jsr Controls
    jsr HandleFire
    jsr UpdateRecoil
    jsr UpdateBullet
    jsr UpdateTarget

    ; Color del tanque: se aclara mientras se carga el disparo.
    lda FireCharge
    lsr
    lsr
    lsr
    lsr
    lsr                    ; 0..5 con FIRE_HOLD = 180
    clc
    adc #6
    ora #$80               ; $86 en reposo, hasta $8B cargado
    sta COLUP0

    ; Destello del fondo al disparar.
    lda #BG_COLOR
    ldx FlashFrames
    beq SetBackground
    dec FlashFrames
    lda #FLASH_COLOR
SetBackground:
    sta COLUBK

    lda Facing
    asl
    asl
    asl
    sta SpriteBase
    lda TurretFacing
    asl
    asl
    asl
    sta TurretBase

    ; Precompute the 8 OR-combined rows during VBLANK.
    ldx #7
ComposeLoop:
    txa
    clc
    adc SpriteBase
    tay
    lda TankSprites,y
    sta HullRow
    txa
    clc
    adc TurretBase
    tay
    lda TurretSprites,y
    ora HullRow
    sta CompositeRows,x
    dex
    bpl ComposeLoop

    ; --- Posicionamiento horizontal ---
    ; Primero se fijan las posiciones gruesas (RESxx) y los ajustes finos
    ; (HMxx) de AMBOS objetos, y al final se hace UN SOLO HMOVE.
    ; Despues del HMOVE no se escribe ningun HMxx (el TIA tarda ~24 ciclos
    ; en aplicarlo y escribir antes lo corrompe).
    lda TankX
    ldx #0                 ; 0 = player 0
    jsr SetHorizPos

    lda TargetX
    ldx #1
    jsr SetHorizPos

    lda #0
    sta HMM0               ; sin movimiento fino si no hay bala
    lda BulletActive
    beq ApplyMotion
    lda BulletX
    ldx #2                 ; 2 = missile 0
    jsr SetHorizPos
ApplyMotion:
    sta WSYNC
    sta HMOVE

WaitBlank:
    lda INTIM
    bne WaitBlank          ; al salir A = 0
    sta WSYNC
    sta VBLANK             ; A = 0: enciende video
    sta TankByte           ; la fila 0 nunca tiene tanque ni bala
    sta MissileVal
    sta TargetByte
    ldx #0

; Kernel: GRP0 y ENAM0 se escriben al INICIO de la linea (todavia en HBLANK),
; usando datos calculados durante la linea anterior. Asi el tanque y la bala
; no cambian de fila segun su posicion horizontal.
