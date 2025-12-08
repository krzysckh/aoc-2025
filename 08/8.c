#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define uint unsigned int

typedef struct Box {
  int x, y, z;
} Box;

typedef struct {
  float dist;
  struct Box *a, *b;
} Dist;

Box b[1024] = {0};
uint nb = 0;
Box *lb[1024][1024] = {0};
uint lbn[1024] = {0};

Dist lens[1024 * 1024] = {0};

float
dist(Box *a, Box *b)
{
  return sqrt(pow(a->x - b->x, 2) + pow(a->y - b->y, 2) + pow(a->z - b->z, 2));
}

int
compar(const void *_a, const void *_b)
{
  const Dist *a = _a, *b = _b;
  if (a->dist < b->dist)
    return -1;
  if (a->dist > b->dist)
    return 1;
  return 0;
}

int
compari(const void *_a, const void *_b)
{
  const int a = *(int*)_a, b = *(int*)_b;
  if (a < b) return 1;
  if (a > b) return -1;
  return 0;
}

int
search(Box *b)
{
  uint i, j;
  for (i = 0; i < nb; ++i) {
    for (j = 0; j < lbn[i]; ++j) {
      if (lb[i][j] == b)
        return i;
    }
  }
  return -1;
}

void
putb(Box *b)
{
  printf("Box(%d %d %d)\n", b->x, b->y, b->z);
}

void
app(Box *a, Box *b)
{
  int sa = search(a), sb = search(b);
  if (sa != sb) {
    memcpy(lb[sa]+lbn[sa], lb[sb], lbn[sb]*sizeof(Box));
    lbn[sa] += lbn[sb];
    lbn[sb] = 0;
  }
}

int
max(void)
{
  uint m = 0, i;
  for (i = 0; i < nb; ++i)
    m = lbn[i] > m ? lbn[i] : m;

  return m;
}

int
main(void)
{
  FILE *f = fopen("input", "r");
  uint i, j, v = 0, m;
  int lbnp[1024];
  Dist d;
  while (!feof(f)) {
    assert(fscanf(f, "%d,%d,%d\n", &b[nb].x, &b[nb].y, &b[nb].z) == 3);
    ++nb;
  }

  for (i = 0; i < nb; ++i) {
    for (j = i; j < nb; ++j) {
      if (j == i) continue;
      lens[v].dist = dist(&b[i], &b[j]);
      lens[v].a = &b[i], lens[v].b = &b[j];
      v++;
    }
  }

  for (i = 0; i < nb; ++i) {
    lb[i][0] = &b[i];
    lbn[i] = 1;
  }

  qsort(lens, v, sizeof(Dist), compar);

  for (i = 0; 1; i++) {
    d = lens[i];
    if (i == 1000) {
      memcpy(lbnp, lbn, 1024*sizeof(int));
      qsort(lbnp, nb, sizeof(int), compari);
      printf("p1: %d\n", lbnp[0]*lbnp[1]*lbnp[2]);
    }

    if (d.a != d.b)
      app(d.a, d.b);
    m = max();
    if (m == nb) {
      /*
      putb(d.a);
      putb(d.b);
      */
      printf("p2: %d\n", d.a->x * d.b->x);
      break;
    }
  }

  return 0;
}
