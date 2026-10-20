; Pantalla de titulo "PANZER 2600": playfield SIN espejo, 6 registros de PF por scanline
; (misma tecnica que el marcador). Sobrio: letras blancas/grises, sin animacion de color.
    MAC TITLE_LINE
; Una scanline: 6 escrituras de PF leyendo directo de ROM (Y = fila de letra).
; Ventanas (ciclo): PF0 izq <22, PF1 izq <28, PF2 izq <38; PF0 der 28..49,
; PF1 der 39..54, PF2 der 50..65. Los nop dejan PF2 der dentro de su ventana.
    lda TitleP0L,y
    sta PF0
    lda TitleP1L,y
    sta PF1
    lda TitleP2L,y
    sta PF2
    lda TitleP0R,y
    sta PF0
    lda #0
    sta CTRLPF
    lda TitleP1R,y
    sta PF1
    nop
    nop
    lda TitleP2R,y
    sta PF2
    dex                     ; X = scanlines que faltan en esta fila
    bne .Same
    iny                     ; fila siguiente
    ldx TH
    dec TLeft               ; deja Z=1 solo al terminar el bloque
.Same:
    sta WSYNC
    ENDM

; Total exacto: 24+56+16+42+20+8+26 = 192 scanlines (cada preparacion cuenta 1).
TitleFrame:
TtWait:
    lda INTIM
    bne TtWait
    sta WSYNC
    sta VBLANK              ; A = 0
    sta PF0
    sta PF1
    sta PF2
    sta CTRLPF
    sta COLUBK
    ldx #23
    jsr TitleBlank
    lda #$0E                ; PANZER: blanco
    sta COLUPF
    ldy #0
    lda #7
    sta TLeft
    lda #8
    sta TH                  ; 7 filas x 8 lineas = 56
    sta WSYNC               ; linea de preparacion (cuenta como la 24)
    jsr DrawRows
    lda #0                  ; limpiar PF tras PANZER: no arrastrar ultima fila
    sta PF0
    sta PF1
    sta PF2
    ldx #15
    jsr TitleBlank
    lda #$0A                ; 2600: gris
    sta COLUPF
    ldy #7
    lda #7
    sta TLeft
    lda #6
    sta TH                  ; 7 filas x 6 lineas = 42
    sta WSYNC               ; linea de preparacion
    jsr DrawRows
    lda #0                  ; limpiar PF tras 2600: evitar bloques fantasma
    sta PF0
    sta PF1
    sta PF2
    ldx #20
    jsr TitleBlank
    lda FrameCount          ; barra parpadeante (invita a pulsar disparo)
    and #$20
    beq TtNoBar
    lda #$0A
    sta COLUPF
    lda #$F0
    sta PF0
    lda #$FF
    sta PF1
    sta PF2
TtNoBar:
    ldx #8
    jsr TitleBlank
    lda #0
    sta PF0
    sta PF1
    sta PF2
    ldx #26
    jsr TitleBlank
    jmp Overscan

TitleBlank:
    sta WSYNC
    dex
    bne TitleBlank
    rts

; Y = fila inicial, TLeft = filas, TH = scanlines por fila.
DrawRows:
    ldx TH
DrLine:
    TITLE_LINE
    bne DrLine
    rts

; Logica del titulo (corre en el overscan): anima el color y espera el boton de disparo.
TitleLogic:
    inc FrameCount
    lda INPT4
    and INPT4+1             ; bit 7 = 0 si cualquiera pulsa disparo
    bmi TlRet
    lda #2
    sta TitleActive         ; pasa a seleccion de arena
    sta SelFireWait         ; hay que soltar el boton antes de confirmar
    lda #0
    sta SelDirHeld
    jsr InitRound           ; tanques en su sitio para verlos en la arena
    jsr ApplyMap
TlRet:
    rts
