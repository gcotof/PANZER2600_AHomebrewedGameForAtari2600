; Milestone 2.8 - Competitive Arena System
;  2.8.1 LoadArena: carga una arena de ArenaTable a RAM (kernel y colisiones la leen de ahi)
;  2.8.2 ArenaTable: 3 arenas simetricas
;  2.8.3 votacion independiente (J1: SWCHA alto, J2: SWCHA bajo; boton = confirmar)
;  2.8.4 unanimidad o desempate 50/50 (paridad de un contador de frames, tomado al confirmar el 2o)
;  2.8.5 pantalla de seleccion: el muro/obstaculo muestra la arena votada y los
;        pips del marcador muestran el numero de arena de cada jugador
;        (parpadean = sin confirmar, fijos = confirmado)

; Formato (5 bytes): X0, X1, Y0, Y1, PF2.  Mitad izquierda [X0,X1) y espejo [160-X1,160-X0).
ArenaTable:
    .byte 72,80,32,64,$C0    ; 0: pilar central (la arena original)
    .byte 56,72,28,68,$3C    ; 1: dos bloques anchos
    .byte 60,68,20,76,$18    ; 2: dos muros altos con pasillos arriba y abajo

; Entrada: A = indice de arena. Usa TestX/TestY como temporales.
LoadArena:
    sta TestY
    asl
    asl
    clc
    adc TestY               ; indice * 5
    tay
    lda ArenaTable+2,y
    sta ArenaY0
    lda ArenaTable+3,y
    sta ArenaY1
    lda ArenaTable+4,y
    sta ArenaPF2
    ; Limites en X (origen del objeto). Tanque: X0+8 .. X1+15; bala: X0+16 .. X1+16.
    ; Espejo: x' = 160 - x.
    lda ArenaTable,y
    clc
    adc #P0_OFFSET-SPRITE_W+1
    sta ATLL
    lda ArenaTable,y
    clc
    adc #M0_OFFSET
    sta ABLL
    lda #160+P0_OFFSET
    sec
    sbc ArenaTable,y
    sta ATRH
    lda #160+M0_OFFSET
    sec
    sbc ArenaTable,y
    sta ABRH
    lda ArenaTable+1,y
    clc
    adc #P0_OFFSET
    sta ATLH
    lda ArenaTable+1,y
    clc
    adc #M0_OFFSET
    sta ABLH
    lda #160+P0_OFFSET-SPRITE_W+1
    sec
    sbc ArenaTable+1,y
    sta ATRL
    lda #160+M0_OFFSET
    sec
    sbc ArenaTable+1,y
    sta ABRL
    rts

EnterSelect:
    lda #1
    sta ArenaMode
    lda #0
    sta SelVote0
    sta SelVote1
    sta SelConf0
    sta SelConf1
    sta SelDelay0
    sta SelDelay1
    sta Score1
    sta Score2
    sta Winner
    sta BulletActive
    sta S1Act
    sta S2Act
    lda #HIDDEN_Y           ; sin tanques: se ve solo la arena
    sta TankY
    sta Tank2Y
    lda #SEL_START_WAIT
    sta PauseFrames         ; en seleccion PauseFrames es la espera inicial
    lda #WALL_COLOR
    sta WallColor
    rts

ArenaSelectFrame:
    inc FrameCount
    lda PauseFrames
    beq SelRead
    dec PauseFrames
    jmp SelPreview
SelRead:
    lda SWCHA
    lsr
    lsr
    lsr
    lsr                     ; J1: derecha=$08, izquierda=$04 (activos en 0)
    ldx #0
    jsr SelectPlayer
    lda SWCHA
    ldx #1                  ; J2: ya esta en el nibble bajo
    jsr SelectPlayer
    lda SelConf0
    and SelConf1
    beq SelPreview
    ; --- 2.8.4: ambos confirmaron ---
    lda SelVote0
    cmp SelVote1
    beq SelPick             ; unanimidad
    lda FrameCount
    and #1                  ; desempate 50/50
    beq SelPick
    lda SelVote1
SelPick:
    sta ArenaSel
    jsr LoadArena
    lda #WALL_COLOR
    sta WallColor
    lda #0
    sta ArenaMode
    sta Score1
    sta Score2
    lda #SEL_REVEAL
    sta PauseFrames         ; pausa mostrando la arena; EndPause arranca la ronda 1
    rts

; --- Vista previa: arena votada (alterna entre ambas si difieren) + pips ---
SelPreview:
    lda SelVote0
    ldy #WALL_COLOR         ; gris = acuerdo
    cmp SelVote1
    beq SelShow
    ldy #HUD_P1_COLOR       ; azul = voto del J1
    lda FrameCount
    and #$20
    beq SelShow
    ldy #TANK2_COLOR        ; verde = voto del J2
    lda SelVote1
    jmp SelShow2
SelShow:
    lda SelVote0
SelShow2:
    sty WallColor
    jsr LoadArena
    ldx #1
SelPips:
    lda SelConf0,x
    bne SelPipOn            ; confirmado: fijo
    lda FrameCount
    and #$10
    beq SelPipOn
    lda #0                  ; sin confirmar: parpadea
    beq SelPipSet
SelPipOn:
    lda SelVote0,x
    clc
    adc #1
SelPipSet:
    sta Score1,x            ; Score1/Score2 son contiguos
    dex
    bpl SelPips
    rts

; Entrada: X = jugador (0/1), A = nibble del joystick. Cambia el voto y lee el boton.
SelectPlayer:
    sta TestX
    lda SelConf0,x
    bne SelDone             ; confirmado: voto bloqueado
    lda PauseFrames
    bne SelDone             ; espera inicial
    lda TestX
    and #$0C
    cmp #$0C
    beq SelNoDir
    lda SelDelay0,x
    beq SelDirGo
    dec SelDelay0,x
    jmp SelFire
SelDirGo:
    lda #SEL_REPEAT
    sta SelDelay0,x
    lda TestX
    and #$08
    beq SelRight
    dec SelVote0,x          ; izquierda
    bpl SelFire
    lda #ARENA_COUNT-1
    sta SelVote0,x
    jmp SelFire
SelRight:
    inc SelVote0,x
    lda SelVote0,x
    cmp #ARENA_COUNT
    bcc SelFire
    lda #0
    sta SelVote0,x
    jmp SelFire
SelNoDir:
    lda #0
    sta SelDelay0,x
SelFire:
    lda INPT4,x             ; INPT4/INPT5 son contiguos; activo en 0
    bmi SelDone
    lda #1
    sta SelConf0,x
SelDone:
    rts
