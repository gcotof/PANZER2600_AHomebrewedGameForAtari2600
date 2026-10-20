TankX         = $80
TankY         = $81
Facing        = $82
Row           = $83
TurnDelay     = $84
StepX         = $85
StepY         = $86
DriveDelay    = $87
DiagonalPhase = $88
SpriteBase    = $89
TurretFacing  = $8A
TurretBase    = $8B
HullRow       = $8C
BulletX       = $8D
BulletY       = $8E
BulletDX      = $8F
BulletDY      = $90
BulletActive  = $91
FireLatch     = $92
BulletDelay   = $93
CompositeRows = $94    ; 8 bytes: $94..$9B
TankByte      = $9C    ; GRP0 de la siguiente scanline
MissileVal    = $9D    ; ENAM0 de la siguiente scanline
FireCharge    = $9E    ; frames que lleva cargandose el disparo
RecoilFrames  = $9F    ; frames de retroceso que faltan
RecoilDX      = $A0    ; paso de retroceso (con signo)
RecoilDY      = $A1
FlashFrames   = $A2    ; frames de destello del fondo que faltan


TargetX = $A3
TargetY = $A4
TargetByte = $A5
TargetRespawn = $A6
TargetHits = $A7
TestX = $A8
TestY = $A9
Tank2X = $AA
Tank2Y = $AB
Facing2 = $AC
Turret2Facing = $AD
Turn2Delay = $AE
Drive2Delay = $AF
Diagonal2Phase = $B0
Tank2Rows = $B1
BulletOwner = $B9
Fire2Charge = $BA
Fire2Latch = $BB
Recoil2Frames = $BC
Recoil2DX = $BD
Recoil2DY = $BE
Score1 = $BF
Score2 = $C0
S1X = $C1
S1Y = $C2
S1DX = $C3
S1DY = $C4
S1Act = $C5
S1Del = $C6
S2X = $C7
S2Y = $C8
S2DX = $C9
S2DY = $CA
S2Act = $CB
S2Del = $CC
FrameCount = $CD
Lock1Frames = $CE
Lock2Frames = $CF
BulletBounce = $D0
PrevX = $D1
PrevY = $D2
BounceMask = $D3
S1Bnc = $D4
S2Bnc = $D5
PauseFrames = $D6
Winner = $D7
HudL1 = $D8
HudL2 = $D9
HudR1 = $DA
HudR2 = $DB
HudL0 = $DC
HudDL0 = $DD
HudDL1 = $DE
HudDL2 = $DF
HudDR1 = $E0
HudDR2 = $E1
HudR0 = $E2
HudDR0 = $E3

; --- Milestone 2.9: mapas por bandas de playfield ---
MapNum  = $E4   ; mapa actual (0..MAP_COUNT-1)
MapBase = $E5   ; MapNum*MAP_BANDS: indice de su banda 0 en MapPF1/MapPF2
BandIdx = $E6   ; kernel: siguiente banda a cargar
PF1Cur  = $E7   ; kernel: PF1/PF2 de la banda en pantalla
PF2Cur  = $E8
WallCol = $E9   ; temporales de colision por celdas
WallEnd = $EA   ; la pila vive en $F8..$FF)
TitleActive = $EB   ; 1 = pantalla de titulo
TBase       = $EC   ; color base animado del titulo
TCol        = $ED
TCnt        = $EE
TLeft       = $EF
TH          = $F0   ; ($F1..$F7 libres; la pila vive en $F8..$FF)

SelFireWait = $F1   ; 1 = esperar a soltar el boton antes de confirmar arena
SelDirHeld  = $F2   ; 1 = direccion ya procesada (un cambio por pulsacion)

; --- Sonido (2.10): vive en el banco 1 (src/bank1.asm) ---
; RAM reutilizada: Target* ($A3,$A4,$A6,$A7) ya no se usa (target.asm es codigo muerto).
PrevB1   = $A3   ; Bnc previo J1 (detecta rebotes)
PrevB2   = $A4
PrevSc   = $A6   ; Score1+Score2 previo (detecta impactos)
PrevFl   = $A7   ; bits previos: 0 FireLatch1, 1 FireLatch2, 2 Winner, 3 menu de arena
PrevMap  = $F7
Snd0Ptr  = $F3   ; canal 0: indice en SfxData
Snd1Ptr  = $F4
Snd0Time = $F5   ; frames que quedan del paso actual
Snd1Time = $F6
