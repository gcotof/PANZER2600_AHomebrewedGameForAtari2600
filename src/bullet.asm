; Bullet moves one pixel in each active axis every 3 frames.
; Diagonal bullets therefore move faster in Euclidean distance.
UpdateBullet:
    lda BulletActive
    beq BulletDone
    lda BulletX
    sta PrevX
    lda BulletY
    sta PrevY
    lda BulletDX
    beq BulletYStep
    bmi BulletXNeg
    lda BulletX
    clc
    adc #BULLET_SPEED
    jmp BulletXStore
BulletXNeg:
    lda BulletX
    sec
    sbc #BULLET_SPEED
BulletXStore:
    ; Wrap (0 -> 252) queda por encima de 200 y mata la bala; las barreras
    ; laterales las maneja UpdateWall con BULLET_MIN_X / BULLET_MAX_X.
    cmp #200
    bcs KillBullet
    sta BulletX
BulletYStep:
    lda BulletDY
    beq BulletDone
    bmi BulletYNeg
    lda BulletY
    clc
    adc #BULLET_SPEED
    jmp BulletYStore
BulletYNeg:
    lda BulletY
    sec
    sbc #BULLET_SPEED
BulletYStore:
    cmp #BULLET_MIN_Y
    bcc BounceY
    cmp #BULLET_MAX_Y
    bcs BounceY
    sta BulletY
BulletDone:
    rts
KillBullet:
    lda #0
    sta BulletActive
    lda #192
    sta BulletY
    rts

; Rebote contra techo/suelo: invierte DY y deja la bala en su posicion anterior.
; Con BulletBounce = 0 la bala muere (comportamiento sin rebotes).
BounceY:
    lda BulletBounce
    beq KillBullet
    dec BulletBounce
    lda BulletDY
    eor #$FF
    clc
    adc #1
    sta BulletDY
RestorePos:
    lda PrevX
    sta BulletX
    lda PrevY
    sta BulletY
    rts
