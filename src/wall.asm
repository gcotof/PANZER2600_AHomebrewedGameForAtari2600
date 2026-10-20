UpdateWall:
    lda BulletActive
    beq WallDone
    lda BulletX
    sta TestX
    lda BulletY
    sta TestY
    jsr BulletInPillar
    bcc SideWalls
    jmp PillarHit
SideWalls:
    lda BulletDX
    beq WallDone
    bmi CheckLeftWall
CheckRightWall:
    lda BulletX
    cmp #BULLET_MAX_X
    bcc WallDone
    jmp BounceX
CheckLeftWall:
    lda BulletX
    cmp #BULLET_MIN_X
    bcs WallDone
    jmp BounceX
WallHit:
    lda #0
    sta BulletActive
    lda #192
    sta BulletY
WallDone:
    rts

; Rebote contra muro lateral: invierte DX.
BounceX:
    lda BulletBounce
    beq WallHit
    dec BulletBounce
    lda BulletDX
    eor #$FF
    clc
    adc #1
    sta BulletDX
    jmp RestorePos

; Rebote contra el pilar: averigua con que eje se entro al pilar.
PillarHit:
    lda BulletBounce
    beq WallHit
    dec BulletBounce
    lda #0
    sta BounceMask
    lda BulletX
    sta TestX
    lda PrevY
    sta TestY
    jsr BulletInPillar
    bcc PillarTestY
    lda #1
    sta BounceMask          ; mover solo en X ya entra: pared vertical
PillarTestY:
    lda PrevX
    sta TestX
    lda BulletY
    sta TestY
    jsr BulletInPillar
    bcc PillarFlip
    lda BounceMask
    ora #2
    sta BounceMask          ; mover solo en Y ya entra: pared horizontal
PillarFlip:
    lda BounceMask
    bne PillarDo
    lda #3                  ; esquina: invierte ambos
    sta BounceMask
PillarDo:
    lsr BounceMask
    bcc PillarNoX
    lda BulletDX
    eor #$FF
    clc
    adc #1
    sta BulletDX
PillarNoX:
    lsr BounceMask
    bcc PillarNoY
    lda BulletDY
    eor #$FF
    clc
    adc #1
    sta BulletDY
PillarNoY:
    jmp RestorePos

; Entrada: TestX, TestY (origen de la bala). Salida: C=1 si toca una celda solida del mapa.
; Pantalla: x = TestX-16 (1 px); filas TestY y TestY+1 (puede tocar 2 bandas).
BulletInPillar:
    lda TestX
    sec
    sbc #M0_OFFSET
    lsr
    lsr
    sta WallCol
    lda TestY
    sec
    sbc #BAND_ROW0
    sta WallEnd
    lsr
    lsr
    clc
    adc MapBase
    tay
    lda WallCol
    jsr CellSolid
    bcs BipRet
    lda WallEnd
    and #3
    cmp #3                  ; C=1 solo si la 2a fila cae en la banda siguiente
    bcc BipRet              ; (retorna C=0)
    iny
    lda WallCol
    jmp CellSolid
BipRet:
    rts

; A = columna de pantalla 0..39 (x/4), Y = MapBase+banda. Salida: C=1 si hay muro.
; Conserva Y. Columnas 0..3 (muro lateral/PF0) y >=40 cuentan como libres: los
; limites los manejan TANK_MIN/MAX_X y BULLET_MIN/MAX_X.
CellSolid:
    cmp #20
    bcc CsHalf
    eor #$FF
    clc
    adc #40                 ; espejo: 39-col
    cmp #20
    bcs CsNo                ; col >= 40
CsHalf:
    tax
    lda ColMask,x
    cpx #12
    bcs CsPF2
    and MapPF1,y
    bne CsYes
CsNo:
    clc
    rts
CsPF2:
    and MapPF2,y
    beq CsNo
CsYes:
    sec
    rts

; Tanque (8x8): solo se revisa el borde DELANTERO segun el signo del paso.
; Entrada: TestX/TestY = posicion nueva. Salida: C=1 si choca.
TankHitsX:
    lda TestY
    clc
    adc #7-BAND_ROW0        ; banda inferior: (Y+7-fila0)/4
    lsr
    lsr
    clc
    adc MapBase
    sta WallEnd
    lda TestY
    sec
    sbc #BAND_ROW0          ; banda superior
    lsr
    lsr
    clc
    adc MapBase
    tay
    lda TestX
    sec
    sbc #8                  ; borde derecho: pantalla x = X-8
    ldx StepX
    bpl TxGo
    sbc #7                  ; borde izquierdo: X-15
TxGo:
    lsr
    lsr                     ; columna de pantalla
    cmp #20
    bcc TxHalf
    eor #$FF
    clc
    adc #40                 ; espejo
    cmp #20
    bcs ThNo
TxHalf:
    tax
    lda ColMask,x
    sta WallCol             ; mascara de la celda (misma para todas las bandas)
    cpx #12
    bcs TxPF2
TxPF1:
    lda MapPF1,y
    and WallCol
    bne ThYes
    cpy WallEnd
    beq ThNo
    iny
    bne TxPF1
TxPF2:
    lda MapPF2,y
    and WallCol
    bne ThYes
    cpy WallEnd
    beq ThNo
    iny
    bne TxPF2
ThNo:
    clc
    rts
ThYes:
    sec
    rts

TankHitsY:
    lda TestY
    ldy StepY
    bpl TyDown
    sec
    sbc #BAND_ROW0          ; borde superior
    jmp TyBand
TyDown:
    clc
    adc #7-BAND_ROW0        ; borde inferior
TyBand:
    lsr
    lsr
    clc
    adc MapBase
    tay
    lda TestX
    sec
    sbc #8
    lsr
    lsr
    sta WallEnd             ; columna derecha
    lda TestX
    sec
    sbc #15
    lsr
    lsr
    sta WallCol             ; columna izquierda
TyLoop:
    lda WallCol
    jsr CellSolid
    bcs ThRet
    lda WallCol
    cmp WallEnd
    clc
    beq ThRet
    inc WallCol
    bne TyLoop
    rts
ThRet:
    rts
