; Posicionamiento horizontal generico (misma rutina validada).
; Entrada: A = posicion X; X = 0 (player 0) o 2 (missile 0).
; RESP0,x y HMP0,x apuntan a RESM0 y HMM0 cuando X = 2.
; NO hace HMOVE: el llamador lo hace una sola vez al final.
SetHorizPos:
    sec
    sta WSYNC
DivideLoop:
    sbc #15
    bcs DivideLoop
    eor #7
    asl
    asl
    asl
    asl
    sta RESP0,x
    sta HMP0,x
    rts

