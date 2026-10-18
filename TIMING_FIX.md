# Milestone 2.4.2 — Auditoría de kernel (experimental)

## Qué se corrigió

En la versión 2.4 el bucle `Visible` consultaba `BulletActive` y `TargetRespawn` **en cada scanline**. Cuando coincidían tanque, bala y blanco, la ruta era demasiado larga y podía desbordar el presupuesto de 76 ciclos de CPU por línea.

Ahora se usa `192` como centinela de coordenada Y para objetos ocultos. Esto elimina dos verificaciones por línea. `UpdateTarget`, `UpdateBullet` y `Reset` mantienen ese invariante. El disparo vuelve a colocar la coordenada Y real al activarse.

**Presupuesto aproximado de la ruta más larga:** 20 ciclos de escrituras iniciales + 16 bala + 20 tanque + 18 blanco + 8 final = **82 ciclos** incluyendo `WSYNC` y salto de vuelta. Este presupuesto sigue siendo **demasiado ajustado** y puede desbordar. Esta versión es una mejora parcial, no una garantía de señal NTSC estable.

## Pruebas

```sh
make clean && make run
```

Comparar en Stella con 2.4.1: imagen quieta, carga, disparo, blanco alcanzado y respawn. Si el desplazamiento persiste, se necesita un kernel de dos líneas o un rediseño de precálculo de objetos. No se debe considerar corregido hasta medirlo.
