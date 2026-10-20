#!/usr/bin/env python3
"""Genera src/titledata.asm (texto del titulo en playfield sin espejo: 40 celdas)."""
F = {
'P':"####.|#...#|#...#|####.|#....|#....|#....",
'A':".###.|#...#|#...#|#####|#...#|#...#|#...#",
'N':"#...#|##..#|#.#.#|#..##|#...#|#...#|#...#",
'Z':"#####|....#|...#.|..#..|.#...|#....|#####",
'E':"#####|#....|#....|####.|#....|#....|#####",
'R':"####.|#...#|#...#|####.|#.#..|#..#.|#...#",
'2':".###.|#...#|....#|..##.|.#...|#....|#####",
'6':".###.|#....|#....|####.|#...#|#...#|.###.",
'0':".###.|#...#|#..##|#.#.#|##..#|#...#|.###."}
def rows(word):
    g = [F[c].split('|') for c in word]
    w = len(word) * 6 - 1; x0 = (40 - w) // 2; out = []
    for r in range(7):
        line = ['.'] * 40
        for i, gl in enumerate(g):
            for k, ch in enumerate(gl[r]):
                if ch == '#': line[x0 + i * 6 + k] = '#'
        out.append(line)
    return out
def regs(line):
    b = [0] * 6
    for c in range(40):
        if line[c] != '#': continue
        h, cc = divmod(c, 20)
        if cc < 4: b[h*3] |= 1 << (4 + cc)
        elif cc < 12: b[h*3+1] |= 1 << (7 - (cc - 4))
        else: b[h*3+2] |= 1 << (cc - 12)
    return b
R = [regs(l) for w in ("PANZER", "2600") for l in rows(w)]
o = ["; GENERADO por tools/gentitle.py - una tabla por registro, indexada por fila (0-6 PANZER, 7-13 2600)"]
for k, n in enumerate(("P0L", "P1L", "P2L", "P0R", "P1R", "P2R")):
    o.append("Title%s:" % n); o.append("    .byte " + ",".join("%%%s" % format(r[k], '08b') for r in R))
open("src/titledata.asm", "w").write("\n".join(o) + "\n")
