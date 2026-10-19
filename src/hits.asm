; Impacto de bala contra el tanque rival (la bala es unica; BulletOwner 0=J1, 1=J2).
; Bala (origen X) golpea tanque si 0 <= BulletX-TX-1 < 8 y 0 <= BulletY-TY+1 < 9.
UpdateHits:
    lda BulletActive
    beq HitsDone
    lda BulletOwner
    bne CheckTank1Hit
CheckTank2Hit:
    lda BulletX
    sec
    sbc Tank2X
    sec
    sbc #1
    cmp #8
    bcs HitsDone
    lda BulletY
    sec
    sbc Tank2Y
    clc
    adc #1
    cmp #9
    bcs HitsDone
    inc Score1
    lda #120
    sta Tank2X
    lda #88
    sta Tank2Y
    lda #0
    sta Recoil2Frames
    jmp KillShot
CheckTank1Hit:
    lda BulletX
    sec
    sbc TankX
    sec
    sbc #1
    cmp #8
    bcs HitsDone
    lda BulletY
    sec
    sbc TankY
    clc
    adc #1
    cmp #9
    bcs HitsDone
    inc Score2
    lda #56
    sta TankX
    lda #88
    sta TankY
    lda #0
    sta RecoilFrames
KillShot:
    lda #0
    sta BulletActive
    lda #192
    sta BulletY
    lda #FLASH_LEN
    sta FlashFrames
HitsDone:
    rts
