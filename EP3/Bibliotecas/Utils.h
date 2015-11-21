#include <stdio.h>

#ifndef STRUCT_MATRIZ_DEF
#define STRUCT_MATRIZ_DEF

typedef struct matriz_t {
    double **M;
    int    n, m;
} Matriz;

#endif

Matriz matalloc(int n, int m);
void matfree(Matriz A);
