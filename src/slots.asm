; Dos balas independientes (una por tanque). El resto del codigo y el kernel
; trabajan con las variables Bullet*; aqui se cargan/guardan desde cada slot.
; El kernel solo dibuja una bala por frame (M0); si ambas estan activas se
; alternan frames (parpadeo solo en las balas).
LoadSlot1:
    lda S1X
    sta BulletX
    lda S1Y
    sta BulletY
    lda S1DX
    sta BulletDX
    lda S1DY
    sta BulletDY
    lda S1Act
    sta BulletActive
    lda S1Del
    sta BulletDelay
    lda #0
    sta BulletOwner
    rts
SaveSlot1:
    lda BulletX
    sta S1X
    lda BulletY
    sta S1Y
    lda BulletDX
    sta S1DX
    lda BulletDY
    sta S1DY
    lda BulletActive
    sta S1Act
    lda BulletDelay
    sta S1Del
    rts
LoadSlot2:
    lda S2X
    sta BulletX
    lda S2Y
    sta BulletY
    lda S2DX
    sta BulletDX
    lda S2DY
    sta BulletDY
    lda S2Act
    sta BulletActive
    lda S2Del
    sta BulletDelay
    lda #1
    sta BulletOwner
    rts
SaveSlot2:
    lda BulletX
    sta S2X
    lda BulletY
    sta S2Y
    lda BulletDX
    sta S2DX
    lda BulletDY
    sta S2DY
    lda BulletActive
    sta S2Act
    lda BulletDelay
    sta S2Del
    rts

; Deja en Bullet* la bala que se dibujara este frame.
PickDraw:
    inc FrameCount
    lda S1Act
    beq DrawSlot2
    lda S2Act
    beq DrawSlot1
    lda FrameCount
    and #1
    beq DrawSlot1
DrawSlot2:
    jmp LoadSlot2
DrawSlot1:
    jmp LoadSlot1
