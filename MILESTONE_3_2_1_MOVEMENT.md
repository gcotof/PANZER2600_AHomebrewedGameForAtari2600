# Milestone 3.2.1 — Movimiento de 16 orientaciones (experimental)

Corrige el movimiento de los dos tanques en los angulos intermedios.

- NNE/NNW/SSE/SSW: dos pasos sobre Y por cada paso sobre X.
- ENE/ESE/WSW/WNW: dos pasos sobre X por cada paso sobre Y.
- NE/SE/SW/NW: alternancia 1:1 entre X e Y (igual que antes).
- N/E/S/W: un solo eje (igual que antes).
- Reversa utiliza los mismos pasos con signo contrario.
- Se reutiliza `DiagonalPhase` / `Diagonal2Phase`; no se consume RAM adicional.
- Se conserva el kernel y las rutinas de rebote/disparo.

**Pendiente:** los sprites de casco todavia usan ocho siluetas, y el recoil
aun usa vectores unitarios. El movimiento a 22.5 grados es una aproximacion
discreta 2:1 (26.6 grados), no trigonometria exacta. La proxima iteracion
puede mejorar a una proporcion 5:2 y sincronizar recoil.

Compilar: `make clean && make run`.
