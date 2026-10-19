; 16 orientaciones: N,NNE,NE,ENE,E,ESE,SE,SSE,S,SSW,SW,WSW,W,WNW,NW,NNW
; Movimiento/recoil: signo por eje. Proyectiles: magnitud 1=2 px, 2=4 px por frame.
; Movimiento original de 8 direcciones: casco exclusivamente.
HullDeltaX:
    .byte 0,1,1,1,0,$FF,$FF,$FF
HullDeltaY:
    .byte $FF,$FF,0,1,1,1,0,$FF

; Direcciones de torreta 0..15, independientes del casco.
DeltaX:
    .byte 0,1,1,1,1,1,1,1,0,$FF,$FF,$FF,$FF,$FF,$FF,$FF
DeltaY:
    .byte $FF,$FF,$FF,$FF,0,1,1,1,1,1,1,1,0,$FF,$FF,$FF
BulletVecX:
    .byte 0,1,2,2,2,2,2,1,0,$FF,$FE,$FE,$FE,$FE,$FE,$FF
BulletVecY:
    .byte $FE,$FE,$FE,$FF,0,1,2,2,2,2,2,1,0,$FF,$FE,$FE
