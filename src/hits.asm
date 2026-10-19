; Impacto de bala (BulletOwner 0=J1, 1=J2). Siempre golpea al rival; si SELF_HIT=1
; y la bala ya roto, tambien al que disparo.
; BulletHitsBox: TestX/TestY = tanque. C=1 si la bala lo golpea.
BulletHitsBox:
    lda BulletX
    sec
    sbc TestX
    sec
    sbc #1
    cmp #8
    bcs BoxMiss
    lda BulletY
    sec
    sbc TestY
    clc
    adc #1
    cmp #9
    bcs BoxMiss
    sec
    rts
BoxMiss:
    clc
    rts

UpdateHits:
    lda BulletActive
    beq HitsDone
    lda BulletOwner
    bne OwnerIsP2
OwnerIsP1:
    lda Tank2X
    sta TestX
    lda Tank2Y
    sta TestY
    jsr BulletHitsBox
    bcc P1Self
    inc Score1
    jsr HitTank2
    jmp KillShot
P1Self:
    lda #SELF_HIT
    beq HitsDone
    lda BulletBounce
    cmp #BOUNCES
    bcs HitsDone            ; todavia no ha rebotado
    lda TankX
    sta TestX
    lda TankY
    sta TestY
    jsr BulletHitsBox
    bcc HitsDone
    inc Score2
    jsr HitTank1
    jmp KillShot
OwnerIsP2:
    lda TankX
    sta TestX
    lda TankY
    sta TestY
    jsr BulletHitsBox
    bcc P2Self
    inc Score2
    jsr HitTank1
    jmp KillShot
P2Self:
    lda #SELF_HIT
    beq HitsDone
    lda BulletBounce
    cmp #BOUNCES
    bcs HitsDone
    lda Tank2X
    sta TestX
    lda Tank2Y
    sta TestY
    jsr BulletHitsBox
    bcc HitsDone
    inc Score1
    jsr HitTank2
KillShot:
    lda #0
    sta BulletActive
    lda #192
    sta BulletY
    lda #FLASH_LEN
    sta FlashFrames
HitsDone:
    rts
