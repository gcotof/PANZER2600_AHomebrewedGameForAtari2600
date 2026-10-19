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
    ; Salvaguarda contra wrap (0 -> 255). Las barreras laterales las maneja
    ; UpdateWall con BULLET_MIN_X / BULLET_MAX_X; esta guarda solo debe
    ; quedar por encima de BULLET_MAX_X (172) para no matar la bala antes.
    cmp #200
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
    lda #192
    sta BulletY
    rts

