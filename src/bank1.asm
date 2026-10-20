; ===================== BANCO 1 (F8, 8K) : SONIDO =====================
; El banco 0 (juego) esta lleno, asi que el sonido vive aqui. No hay
; ningun "hook" en el juego: el sonido OBSERVA la RAM del juego (disparo,
; rebote, impacto, victoria, menu) y reacciona. Una sola llamada por frame:
; en graphics.asm, SoundCall hace "lda $FFF9" (banco 1), el codigo sigue
; aqui en SoundCall+3, y al final "lda $FFF8" devuelve al banco 0 en OverWait.

    org $10000
    rorg $F000
    sei                     ; (mismos 5 bytes que Reset del banco 0)
    cld
    lda $FFF8
    ; ---- el resto del banco, relleno hasta SoundCall ----
    org $10000+(SoundCall-$F000)
    rorg SoundCall
    lda $FFF8               ; vuelta al banco 0: continua en SoundCall+3 = OverWait
    jmp SoundMain           ; se llega aqui tras "lda $FFF9" del banco 0

    MAC SFX                 ; AUDC, AUDV, AUDF, frames
    .byte (({1})<<4)|({2}), ({3})|((({4})-1)<<5)
    ENDM

; Cada paso = 2 bytes; el byte 0 termina. Graves con cuerpo (cuadrada /31 y
; ruido lento), agudos suaves y cortos: pegada sin estridencia.
SfxData:
    .byte 0,0
SfxFire0:                   ; ch0: THUMP grave que cae
    SFX 6,15,5,1
    SFX 6,15,6,1
    SFX 6,14,8,1
    SFX 6,13,10,1
    SFX 6,11,12,1
    SFX 6,9,14,2
    SFX 6,6,17,2
    SFX 6,3,20,2
    SFX 6,1,24,2
    .byte 0,0
SfxFire1:                   ; ch1: chasquido corto
    SFX 8,12,2,1
    SFX 8,11,4,1
    SFX 8,9,6,1
    SFX 8,7,9,1
    SFX 8,5,12,2
    SFX 8,3,16,2
    SFX 8,1,20,2
    .byte 0,0
SfxHit0:                    ; ch0: explosion (crack + rumor grave)
    SFX 8,13,6,2
    SFX 8,15,16,3
    SFX 8,14,20,4
    SFX 8,12,24,5
    SFX 8,10,27,6
    SFX 8,8,29,6
    SFX 8,5,31,6
    SFX 8,3,31,6
    SFX 8,1,31,6
    .byte 0,0
SfxHit1:                    ; ch1: bombo profundo
    SFX 6,15,6,2
    SFX 6,15,9,2
    SFX 6,14,12,3
    SFX 6,12,15,3
    SFX 6,10,18,3
    SFX 6,7,22,3
    SFX 6,4,26,3
    SFX 6,2,30,3
    .byte 0,0
SfxWin1:                    ; ch1: bombo + fanfarria ascendente
    SFX 6,15,6,2
    SFX 6,15,9,2
    SFX 6,14,12,3
    SFX 6,12,15,3
    SFX 6,10,18,3
    SFX 6,7,22,3
    SFX 1,0,0,6
    SFX 6,10,4,5
    SFX 6,10,3,5
    SFX 6,10,2,5
    SFX 6,10,1,8
    SFX 6,8,1,8
    SFX 6,5,1,8
    SFX 6,3,1,8
    .byte 0,0
SfxBounce1:                 ; "tink" corto y bajito
    SFX 12,7,8,1
    SFX 12,6,9,1
    SFX 12,4,10,1
    SFX 12,3,11,1
    SFX 12,1,12,1
    .byte 0,0
SfxMenu1:                   ; cambio de arena
    SFX 12,7,7,2
    SFX 12,5,5,2
    .byte 0,0
SfxConfirm1:                ; arrancar partida
    SFX 12,8,9,3
    SFX 12,8,6,3
    SFX 12,8,4,3
    SFX 12,6,3,5
    SFX 12,3,3,5
    .byte 0,0

; --- disparadores (corrompen A y X) ---
SfxFire:
    ldx #SfxFire1-SfxData
    stx Snd1Ptr
    ldx #SfxFire0-SfxData
    jmp Start0
SfxHit:
    ldx #SfxHit1-SfxData
    stx Snd1Ptr
    ldx #SfxHit0-SfxData
    jmp Start0
SfxWin:
    ldx #SfxWin1-SfxData
    jmp Start1
SfxBounce:
    ldx #SfxBounce1-SfxData
    jmp Start1
SfxMenu:
    ldx #SfxMenu1-SfxData
    jmp Start1
SfxConfirm:
    ldx #SfxConfirm1-SfxData
Start1:
    stx Snd1Ptr
    lda #0
    sta Snd1Time
    rts
Start0:
    stx Snd0Ptr
    lda #0
    sta Snd0Time
    sta Snd1Time            ; ch1 tambien arranca ya (Fire/Hit lo cargaron antes)
    rts

SoundMain:
    ; ---- flags actuales: b0 FireLatch, b1 Fire2Latch, b2 Winner, b3 menu de arena ----
    lda #0
    ldy FireLatch
    beq .f1
    ora #1
.f1:
    ldy Fire2Latch
    beq .f2
    ora #2
.f2:
    ldy Winner
    beq .f3
    ora #4
.f3:
    ldy TitleActive
    cpy #2
    bne .f4
    ora #8
.f4:
    tax                     ; X = actuales
    eor #$FF
    and PrevFl              ; A = bits que cayeron
    pha
    lda PrevFl
    eor #$FF
    stx PrevFl
    and PrevFl              ; A = bits que subieron
    tay                     ; Y = subieron
    pla
    and #8
    beq .noConfirm
    jsr SfxConfirm          ; salio del menu de arena: arranca la partida
.noConfirm:
    tya
    and #8
    beq .noMenuIn
    jsr SfxMenu             ; entro al menu de arena
.noMenuIn:
    tya
    and #3
    beq .noFire
    jsr SfxFire             ; alguien disparo
.noFire:
    ; ---- rebotes: el contador de rebotes de una bala baja ----
    lda S1Bnc
    cmp PrevB1
    sta PrevB1
    bcs .b2
    jsr SfxBounce
.b2:
    lda S2Bnc
    cmp PrevB2
    sta PrevB2
    bcs .b3
    jsr SfxBounce
.b3:
    ; ---- impacto: sube Score1+Score2 (solo en partida; en el menu los pips muestran la arena) ----
    lda Score1
    clc
    adc Score2
    tax
    lda TitleActive
    bne .noHit
    cpx PrevSc
    beq .noHit
    bcc .noHit
    jsr SfxHit
.noHit:
    stx PrevSc
    tya
    and #4
    beq .noWin
    jsr SfxWin              ; gano la partida (despues del impacto: la fanfarria incluye el bombo)
.noWin:
    ; ---- cambio de arena ----
    lda MapNum
    cmp PrevMap
    sta PrevMap
    beq .noMap
    lda TitleActive
    cmp #2
    bne .noMap
    jsr SfxMenu
.noMap:
    ; ---- reproductor: canales 1 y 0 ----
    ldx #1
.ch:
    lda Snd0Time,x
    beq .next
    dec Snd0Time,x
    jmp .nx
.next:
    ldy Snd0Ptr,x
    lda SfxData,y
    beq .off
    sta AUDV0,x             ; el TIA ignora los bits altos (AUDV = 4 bits)
    lsr
    lsr
    lsr
    lsr
    sta AUDC0,x
    lda SfxData+1,y
    sta AUDF0,x             ; AUDF = 5 bits
    lsr
    lsr
    lsr
    lsr
    lsr
    sta Snd0Time,x
    iny
    iny
    tya
    sta Snd0Ptr,x
    jmp .nx
.off:
    sta AUDV0,x             ; A = 0: silencio
.nx:
    dex
    bpl .ch
    jmp SoundCall           ; "lda $FFF8": vuelve al banco 0

    org $10FFC
    rorg $FFFC
    .word $F000
    .word $F000
