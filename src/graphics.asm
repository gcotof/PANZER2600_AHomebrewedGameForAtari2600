    MAC HUD_LINE
    ; Una scanline del marcador, playfield sin espejo (CTRLPF=0).
    ; Parametros: {1}=PF0 izq, {2}=PF1 izq, {3}=PF2 izq, {4}=PF1 der, {5}=PF2 der,
    ;             {6}=color izq, {7}=color der, {8}=PF0 der (valor inmediato).
    ; La mitad izquierda se arma al inicio de la linea; a mitad de linea se
    ; reescriben PF0/PF1/COLUPF/PF2 para la mitad derecha.
    ; Ventanas (ciclo de CPU): PF0 der [28..49], PF1 der [39..54], COLUPF [43..55], PF2 der [50..66].
    lda #{6}
    sta COLUPF
    lda {1}
    sta PF0
    lda {2}
    sta PF1
    lda {3}
    sta PF2
    lda #{8}
    sta PF0
    lda #0
    sta CTRLPF
    lda {4}
    sta PF1
    lda #{7}
    sta COLUPF
    lda {5}
    sta PF2
    sta WSYNC
    ENDM

    MAC KERNEL_LINES
; Una iteracion = 2 scanlines exactas:
;  linea A: escribe GRP0/ENABL/GRP1 (datos calculados en la iteracion anterior)
;  linea B: calcula los datos de la siguiente fila (cabe holgado en 76 ciclos)
.Visible:
    lda TankByte
    sta GRP0
    lda MissileVal
    sta ENABL              ; la bala es el Ball (color = COLUPF = gris)
    lda TargetByte
    sta GRP1
    sta WSYNC

    inx

    ldy #0
    txa
    sec
    sbc BulletY
    cmp #2
    bcs .NoBulletRow
    ldy #2
.NoBulletRow:
    sty MissileVal

    txa
    sec
    sbc TankY
    cmp #8
    bcc .InTank
    lda #0
    beq .StoreTank
.InTank:
    tay
    lda CompositeRows,y
.StoreTank:
    sta TankByte

    txa
    sec
    sbc Tank2Y
    cmp #8
    bcc .InTank2
    lda #0
    beq .StoreTank2
.InTank2:
    tay
    lda Tank2Rows,y
.StoreTank2:
    sta TargetByte

    cpx #{1}
    sta WSYNC
    bne .Visible
    ENDM

    ; Muro superior: PF completo (se activa en VBLANK, ver frame.asm).
    KERNEL_LINES 1
    ; Marcador: 2 filas de kernel = 4 scanlines (sin objetos: filas vacias).
    HUD_LINE HudDL0,HudDL1,HudDL2,HudDR1,HudDR2,HUD_DIM_COLOR,HUD_DIM_COLOR,$10
    HUD_LINE HudDL0,HudDL1,HudDL2,HudDR1,HudDR2,HUD_DIM_COLOR,HUD_DIM_COLOR,$10
    inx
    HUD_LINE HudL0,HudL1,HudL2,HudR1,HudR2,HUD_P1_COLOR,TANK2_COLOR,0
    HUD_LINE HudL0,HudL1,HudL2,HudR1,HudR2,HUD_P1_COLOR,TANK2_COLOR,0
    inx
    ; Fila 4: muro completo otra vez (espejo y color de muro).
    lda #WALL_COLOR
    sta COLUPF
    lda #$F0
    sta PF0
    lda #$FF
    sta PF1
    sta PF2
    lda #PF_MIRROR
    sta CTRLPF
    KERNEL_LINES WALL_TOP_ROWS
    lda #WALL_PF0          ; vuelve a muros laterales
    sta PF0
    lda #0
    sta PF1
    sta PF2
    KERNEL_LINES CWALL_Y0
    lda #CWALL_PF2
    sta PF2
    KERNEL_LINES CWALL_Y1
    lda #0
    sta PF2
    KERNEL_LINES WALL_BOT_START
    lda #$F0               ; muro inferior: PF completo
    sta PF0
    lda #$FF
    sta PF1
    sta PF2
    KERNEL_LINES KERNEL_ROWS

    lda #0
    sta GRP0
    sta ENABL
    sta GRP1
    lda #2
    sta VBLANK
    ldx #30
Overscan:
    sta WSYNC
    dex
    bne Overscan
    jmp Frame
