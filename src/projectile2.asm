HandleFire2:
    lda INPT5
    bmi Fire2Released
    lda Fire2Latch
    bne Fire2Done
    lda SWCHA
    and #$0C
    cmp #$0C
    bne Charge2Reset
    lda Fire2Charge
    cmp #FIRE_HOLD
    bcs Charge2Full
    inc Fire2Charge
    rts
Charge2Full:
    lda BulletActive
    bne Fire2Done
    lda #1
    sta Fire2Latch
    lda #0
    sta Fire2Charge
    ldx Turret2Facing
    lda DeltaX,x
    eor #$FF
    clc
    adc #1
    sta Recoil2DX
    lda DeltaY,x
    eor #$FF
    clc
    adc #1
    sta Recoil2DY
    lda #RECOIL_LEN
    sta Recoil2Frames
    lda #FLASH_LEN
    sta FlashFrames
    lda Tank2X
    clc
    adc #4
    sta BulletX
    lda Tank2Y
    clc
    adc #4
    sta BulletY
    ldx Turret2Facing
    lda DeltaX,x
    sta BulletDX
    lda DeltaY,x
    sta BulletDY
    lda #1
    sta BulletActive
    sta BulletOwner
    lda #0
    sta BulletDelay
Fire2Done:
    rts
Charge2Reset:
    lda #0
    sta Fire2Charge
    rts
Fire2Released:
    lda #0
    sta Fire2Latch
    sta Fire2Charge
    rts

UpdateRecoil2:
    lda Recoil2Frames
    beq Recoil2Done
    dec Recoil2Frames
    lda Recoil2DX
    sta StepX
    lda Recoil2DY
    sta StepY
    jsr ApplyStep2
Recoil2Done:
    rts
