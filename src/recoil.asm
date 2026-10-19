; Recoil: 1 pixel per frame opposite to the turret, for RECOIL_LEN frames.
; ApplyStep keeps the tank inside the arena.
UpdateRecoil:
    lda RecoilFrames
    beq RecoilDone
    dec RecoilFrames
    lda RecoilDX
    sta StepX
    lda RecoilDY
    sta StepY
    jsr ApplyStep
    lda RecoilFrames
    cmp #RECOIL_FAST-1
    bcc RecoilDone
    jsr ApplyStep          ; 2 px/frame al inicio
RecoilDone:
    rts

