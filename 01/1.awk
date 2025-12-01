#!/usr/bin/env -S gawk -f
# -*- mode: awk; c-basic-offset: 2 -*-

BEGIN {
  v  = 50
  p1 = 0
  p2 = 0
}

function mod(a, b) {
  a %= b
  if (a < 0)
    return b+a
  return a
}

{
  match($0, /([LR])([0-9]+)/, m)
  bv = v
  if (m[1] == "L") v -= m[2]
  else             v += m[2]

  n = int(m[2] / 100)
  p2 += n

  if (m[1] == "L") v += n*100
  else             v -= n*100

  if ((v <= 0 || v > 99) && bv != 0)
    p2++

  v = int(mod(v, 100))
  if (v == 0) p1++
}

END {
  printf "p1: %d\n", p1
  printf "p2: %d\n", p2
}
