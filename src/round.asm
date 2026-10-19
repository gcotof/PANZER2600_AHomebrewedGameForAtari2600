; Rondas y victoria.
; Un punto -> el tanque destruido desaparece y hay una pausa; al terminar, nueva ronda.
; Al llegar a WIN_SCORE hay pausa larga con el fondo parpadeando; luego se reinicia la partida.

EndRound:
    lda #ROUND_PAUSE
    sta PauseFrames
    lda #0
    sta Winner
    lda Score2
    cmp #WIN_SCORE
    bcc EndRoundCheck1
    lda #2
    sta Winner
EndRoundCheck1:
    lda Score1
    cmp #WIN_SCORE
    bcc EndRoundDone
    lda #1
    sta Winner
EndRoundDone:
    lda Winner
    beq EndRoundRts
    lda #VICTORY_PAUSE
    sta PauseFrames
EndRoundRts:
    rts

HitTank1:
    lda #HIDDEN_Y
    sta TankY
    jmp EndRound
HitTank2:
    lda #HIDDEN_Y
    sta Tank2Y
    jmp EndRound

; Se llama cuando PauseFrames llega a 0.
EndPause:
    lda Winner
    beq StartRound
    lda #0
    sta Score1
    sta Score2
    sta Winner
StartRound:
    lda #56
    sta TankX
    lda #120
    sta Tank2X
    lda #START_Y
    sta TankY
    sta Tank2Y
    lda #0
    sta Facing
    sta TurretFacing
    sta RecoilFrames
    sta Recoil2Frames
    sta FireCharge
    sta Fire2Charge
    sta Lock1Frames
    sta Lock2Frames
    sta TurnDelay
    sta DriveDelay
    sta Turn2Delay
    sta Drive2Delay
    sta S1Act
    sta S2Act
    sta BulletActive
    lda #6
    sta Facing2
    sta Turret2Facing
    lda #192
    sta S1Y
    sta S2Y
    sta BulletY
    rts

; Marcador (2 filas de kernel), dentro del marco de muros:
;  fila A: TODAS las casillas (WIN_SCORE por jugador) en gris + divisor central.
;  fila B: casillas ganadas en el color de cada jugador.
; Las casillas que solo aparecen grises son las victorias que faltan.
; J1 crece desde el muro izquierdo (PF0 bit6, PF1, PF2), J2 desde el derecho
; (PF2, PF1, PF0 bit7). Las tablas incluyen el bit del muro lateral
; (PF0 bit4 a la izquierda = x0..3; PF2 bit7 a la derecha = x156..159).
PrepHud:
    ldx Score1
    cpx #9
    bcc PrepHud1
    ldx #8
PrepHud1:
    lda PipL0,x
    sta HudL0
    lda PipL1,x
    sta HudL1
    lda PipL2,x
    sta HudL2
    ldx Score2
    cpx #9
    bcc PrepHud2
    ldx #8
PrepHud2:
    lda PipR0,x
    sta HudR0
    lda PipR1,x
    sta HudR1
    lda PipR2,x
    sta HudR2
    IF HUD_B_WALLS == 0
    lda HudL0
    and #$EF
    sta HudL0
    lda HudR2
    and #$7F
    sta HudR2
    ENDIF
    ; fila A: casillas totales + divisor (PF2 izq. bit7 y PF0 der. bit4 = x76..83)
    lda PipL0+WIN_SCORE
    sta HudDL0
    lda PipL1+WIN_SCORE
    sta HudDL1
    lda PipL2+WIN_SCORE
    ora #$80
    sta HudDL2
    lda PipR0+WIN_SCORE
    ora #$10
    sta HudDR0
    lda PipR1+WIN_SCORE
    sta HudDR1
    lda PipR2+WIN_SCORE
    sta HudDR2
    rts

PipL0:
    .byte $10,$50,$50,$50,$50,$50,$50,$50,$50
PipL1:
    .byte $00,$00,$80,$A0,$A8,$AA,$AA,$AA,$AA
PipL2:
    .byte $00,$00,$00,$00,$00,$00,$01,$05,$15
PipR0:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$80
PipR1:
    .byte $00,$00,$00,$00,$01,$05,$15,$55,$55
PipR2:
    .byte $80,$A0,$A8,$AA,$AA,$AA,$AA,$AA,$AA
WinnerColors:
    .byte HUD_P1_COLOR,TANK2_COLOR
