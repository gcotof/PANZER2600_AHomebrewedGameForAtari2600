; Colision de la bala: pilar central + barreras laterales.
UpdateWall:
    lda BulletActive
    beq WallDone
    ; --- pilar central ---
    lda BulletX
    cmp #CWALL_BUL_X_LO
    bcc SideWalls
    cmp #CWALL_BUL_X_HI
    bcs SideWalls
    lda BulletY
    cmp #CWALL_BUL_Y_LO
    bcc SideWalls
    cmp #CWALL_BUL_Y_HI
    bcs SideWalls
    jmp WallHit
SideWalls:
    lda BulletDX
    beq WallDone
    bmi CheckLeftWall
CheckRightWall:
    lda BulletX
    cmp #BULLET_MAX_X
    bcc WallDone
    jmp WallHit
CheckLeftWall:
    lda BulletX
    cmp #BULLET_MIN_X
    bcs WallDone
WallHit:
    lda #0
    sta BulletActive
    lda #192
    sta BulletY
WallDone:
    rts