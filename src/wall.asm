UpdateWall:
    lda BulletActive
    beq WallDone
    lda BulletX
    sta TestX
    lda BulletY
    sta TestY
    jsr BulletInPillar
    bcc SideWalls
    jmp PillarHit
SideWalls:
    lda BulletDX
    beq WallDone
    bmi CheckLeftWall
CheckRightWall:
    lda BulletX
    cmp #BULLET_MAX_X
    bcc WallDone
    jmp BounceX
CheckLeftWall:
    lda BulletX
    cmp #BULLET_MIN_X
    bcs WallDone
    jmp BounceX
WallHit:
    lda #0
    sta BulletActive
    lda #192
    sta BulletY
WallDone:
    rts

; Rebote contra muro lateral: invierte DX.
BounceX:
    lda BulletBounce
    beq WallHit
    dec BulletBounce
    lda BulletDX
    eor #$FF
    clc
    adc #1
    sta BulletDX
    jmp RestorePos

; Rebote contra el pilar: averigua con que eje se entro al pilar.
PillarHit:
    lda BulletBounce
    beq WallHit
    dec BulletBounce
    lda #0
    sta BounceMask
    lda BulletX
    sta TestX
    lda PrevY
    sta TestY
    jsr BulletInPillar
    bcc PillarTestY
    lda #1
    sta BounceMask          ; mover solo en X ya entra: pared vertical
PillarTestY:
    lda PrevX
    sta TestX
    lda BulletY
    sta TestY
    jsr BulletInPillar
    bcc PillarFlip
    lda BounceMask
    ora #2
    sta BounceMask          ; mover solo en Y ya entra: pared horizontal
PillarFlip:
    lda BounceMask
    bne PillarDo
    lda #3                  ; esquina: invierte ambos
    sta BounceMask
PillarDo:
    lsr BounceMask
    bcc PillarNoX
    lda BulletDX
    eor #$FF
    clc
    adc #1
    sta BulletDX
PillarNoX:
    lsr BounceMask
    bcc PillarNoY
    lda BulletDY
    eor #$FF
    clc
    adc #1
    sta BulletDY
PillarNoY:
    jmp RestorePos

; Entrada: TestX, TestY (origen de la bala). Salida: C=1 si esta dentro de un obstaculo
; de la arena actual (izquierdo [ABLL,ABLH) o su espejo [ABRL,ABRH)).
BulletInPillar:
    lda TestY
    clc
    adc #1                  ; BulletY >= Y0-1
    cmp ArenaY0
    bcc PillarOut
    lda TestY
    cmp ArenaY1
    bcs PillarOut
    lda TestX
    cmp ABLL
    bcc BulRightRect
    cmp ABLH
    bcc PillarIn
BulRightRect:
    cmp ABRL
    bcc PillarOut
    cmp ABRH
    bcc PillarIn
PillarOut:
    clc
    rts
PillarIn:
    sec
    rts
