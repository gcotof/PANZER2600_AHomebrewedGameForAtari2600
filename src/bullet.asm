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
    asl                         ; magnitud 1 -> 2px, 2 -> 4px
    clc
    adc BulletX
    jmp BulletXStore
BulletXNeg:
    eor #$FF
    clc
    adc #1
    asl
    sta BulletDelay
    lda BulletX
    sec
    sbc BulletDelay
BulletXStore:
    cmp #200
    bcs KillBullet
    sta BulletX
BulletYStep:
    lda BulletDY
    beq BulletDone
    bmi BulletYNeg
    asl
    clc
    adc BulletY
    jmp BulletYStore
BulletYNeg:
    eor #$FF
    clc
    adc #1
    asl
    sta BulletDelay
    lda BulletY
    sec
    sbc BulletDelay
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
