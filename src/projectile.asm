; Charged shot: keep fire held for FIRE_HOLD frames without rotating the turret.
; Left/right while holding fire rotates the turret and resets the charge.
; After shooting, the button must be released before charging again.
HandleFire:
    lda INPT4
    bmi FireReleased
    lda FireLatch
    bne FireDone           ; ya disparo en esta pulsacion
    lda SWCHA
    and #$C0
    cmp #$C0
    bne ChargeReset        ; girando la torreta: reinicia la carga
    lda FireCharge
    cmp #FIRE_HOLD
    bcs ChargeFull
    inc FireCharge
    rts
ChargeFull:
    lda BulletActive
    bne FireDone           ; cargado, esperando que la bala anterior termine
    lda #1
    sta FireLatch
    lda #0
    sta FireCharge
    ; Retroceso: direccion opuesta a la torreta.
    ldx TurretFacing
    lda DeltaX,x
    eor #$FF
    clc
    adc #1
    sta RecoilDX
    lda DeltaY,x
    eor #$FF
    clc
    adc #1
    sta RecoilDY
    lda #RECOIL_LEN
    sta RecoilFrames
    lda #FLASH_LEN
    sta FlashFrames
    ; Spawn approximately at the center of the 8x8 sprite.
    lda TankX
    clc
    adc #4
    sta BulletX
    lda TankY
    clc
    adc #4
    sta BulletY
    ldx TurretFacing
    lda DeltaX,x
    sta BulletDX
    lda DeltaY,x
    sta BulletDY
    lda #1
    sta BulletActive
    lda #0
    sta BulletDelay
FireDone:
    rts
ChargeReset:
    lda #0
    sta FireCharge
    rts
FireReleased:
    lda #0
    sta FireLatch
    sta FireCharge
    rts

