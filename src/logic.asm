; Logica del juego: corre en el OVERSCAN (ver graphics.asm), no en el VBLANK,
; para tener ~2300 ciclos extra (la colision por celdas es mas cara que los rectangulos).
GameLogic:
    lda TitleActive
    beq GlGame
    cmp #1
    beq GlTitle
    jmp SelectLogic
GlTitle:
    jmp TitleLogic
GlGame:
    lda PauseFrames
    beq PlayFrame
    dec PauseFrames
    bne LogicDone
    jmp EndPause
PlayFrame:
    jsr LoadSlot1
    jsr HandleFire
    jsr UpdateBullet
    jsr UpdateWall
    jsr UpdateHits
    jsr SaveSlot1
    jsr LoadSlot2
    jsr HandleFire2
    jsr UpdateBullet
    jsr UpdateWall
    jsr UpdateHits
    jsr SaveSlot2
    jsr UpdateRecoil2
    jsr PickDraw
LogicDone:
    rts
