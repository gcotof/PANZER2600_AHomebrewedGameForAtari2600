# Milestone 2.4.1 — Diagnóstico de sincronización (sin alterar la ROM)

Esta entrega mantiene exactamente el código fuente de juego del Milestone 2.4.
Solo añade `make timing` y esta guía, para aislar el problema antes de editar el kernel.

## Procedimiento

1. Ejecuta `make run` y deja el tanque quieto unos segundos.
2. Abre el depurador de Stella (según la versión: tecla de acceso al debugger o menú de depuración).
3. Busca el contador de **scanlines por frame** y el de **ciclos en la scanline**.
4. Registra el número de líneas en cuatro situaciones: quieto, cargando disparo,
   instante del disparo (destello/retroceso) e impacto contra el blanco.
5. En NTSC la meta nominal es **262 scanlines por frame**. Si ves 263, 264 o
   valores variables, hay que revisar el kernel y los períodos verticales.
6. Comprueba si el número de líneas cambia cuando el tanque y el blanco comparten altura.
7. En Stella compara el modo de video/zoom entre la ROM 2.3.2 y 2.4.
   No cambies la configuración entre pruebas.

## Sospecha concreta

`src/graphics.asm` calcula en cada scanline el estado del misil, del tanque y del
blanco, con ramas de distinta duración. `STA WSYNC` espera a la próxima línea,
pero si el cálculo ya pasó el límite de 76 ciclos de CPU, se pierde una línea.
Eso puede causar desplazamientos verticales y alterar el total de líneas del frame.

## Qué reportar

- Scanlines/frame quieto:
- Scanlines/frame al disparar:
- Scanlines/frame al impactar:
- ¿El zoom cambia entre 2.3.2 y 2.4 con la misma configuración?:

Nota: los valores del debugger no están verificados en este entorno; no hay DASM
ni Stella instalados aquí. No se modificaron las instrucciones del juego.
