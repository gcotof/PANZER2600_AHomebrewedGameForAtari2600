    processor 6502

VSYNC   = $00
VBLANK  = $01
WSYNC   = $02
COLUP0  = $06
COLUBK  = $09
GRP0    = $1B
RESP0   = $10
HMP0    = $20
HMOVE   = $2A
SWCHA   = $0280
TIM64T  = $0296
INTIM   = $0284

TankX   = $80
TankY   = $81
Facing  = $82
Row     = $83

    org $F000
Reset:
    sei
    cld
    ldx #$FF
    txs
    lda #0
ClearRAM:
    sta $80,x
    dex
    bne ClearRAM
    lda #76
    sta TankX
    lda #88
    sta TankY
    lda #0
    sta Facing
    sta GRP0
    lda #$86
    sta COLUP0
    lda #$22
    sta COLUBK

Frame:
    lda #2
    sta VBLANK
    sta VSYNC
    sta WSYNC
    sta WSYNC
    sta WSYNC
    lda #0
    sta VSYNC
    lda #43
    sta TIM64T
    jsr Controls
    jsr PositionPlayer
WaitBlank:
    lda INTIM
    bne WaitBlank
    sta WSYNC
    lda #0
    sta VBLANK
    ldx #0
Visible:
    stx Row
    txa
    sec
    sbc TankY
    cmp #8
    bcs NoTank
    tay
    lda TankSprite,y
    jmp DrawRow
NoTank:
    lda #0
DrawRow:
    sta GRP0
    sta WSYNC
    ldx Row
    inx
    cpx #192
    bne Visible
    lda #0
    sta GRP0
    lda #2
    sta VBLANK
    ldx #30
Overscan:
    sta WSYNC
    dex
    bne Overscan
    jmp Frame

Controls:
    lda SWCHA
    and #$40
    bne NoLeft
    dec Facing
NoLeft:
    lda SWCHA
    and #$80
    bne NoRight
    inc Facing
NoRight:
    ; Milestone 0: up/down move on screen.
    ; Next milestone: movement follows Facing using direction vectors.
    lda SWCHA
    and #$10
    bne NoUp
    lda TankY
    beq NoUp
    dec TankY
NoUp:
    lda SWCHA
    and #$20
    bne NoDown
    lda TankY
    cmp #184
    bcs NoDown
    inc TankY
NoDown:
    rts

PositionPlayer:
    lda TankX
    ldx #0
    sta WSYNC
Divide15:
    sec
    sbc #15
    bcs Divide15
    eor #7
    asl
    asl
    asl
    asl
    sta HMP0
    sta RESP0
    sta WSYNC
    sta HMOVE
    rts

TankSprite:
    .byte %00111100
    .byte %01111110
    .byte %11111111
    .byte %11011011
    .byte %11011011
    .byte %11111111
    .byte %01111110
    .byte %00111100

    org $FFFC
    .word Reset
    .word Reset
