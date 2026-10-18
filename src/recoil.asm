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
RecoilDone:
    rts

