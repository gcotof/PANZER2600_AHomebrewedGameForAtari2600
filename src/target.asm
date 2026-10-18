; CXM0P bit 7: missile 0 hits player 1.
UpdateTarget:
    lda CXM0P
    and #$80
    beq TargetNoHit
    lda TargetRespawn
    bne TargetNoHit
    lda BulletActive
    beq TargetNoHit
    lda #0
    sta BulletActive
    lda #192
    sta BulletY
    lda #TARGET_RESPAWN_FRAMES
    sta TargetRespawn
    lda #192
    sta TargetY
    inc TargetHits
TargetNoHit:
    lda #0
    sta CXCLR
    lda TargetRespawn
    beq TargetDone
    dec TargetRespawn
    bne TargetDone
    lda TargetHits
    and #1
    beq TargetPositionA
    lda #32
    sta TargetX
    lda #120
    sta TargetY
    rts
TargetPositionA:
    lda #112
    sta TargetX
    lda #64
    sta TargetY
TargetDone:
    rts
