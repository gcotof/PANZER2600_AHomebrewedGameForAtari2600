; Bullet moves one pixel in each active axis every 3 frames.
; Diagonal bullets therefore move faster in Euclidean distance.
UpdateBullet:
    lda BulletActive
    beq BulletDone
    lda BulletDelay
    beq BulletReady
    dec BulletDelay
    rts
BulletReady:
    lda #2
    sta BulletDelay
    lda BulletX
    clc
    adc BulletDX
    cmp #4
    bcc KillBullet
    cmp #156
    bcs KillBullet
    sta BulletX
    lda BulletY
    clc
    adc BulletDY
    cmp #4
    bcc KillBullet
    cmp #188
    bcs KillBullet
    sta BulletY
BulletDone:
    rts
KillBullet:
    lda #0
    sta BulletActive
    rts

