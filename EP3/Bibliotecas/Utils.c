#include <stdio.h>
#include <stdlib.h>
#include "Utils.h"

// Aloca uma matriz A (n×m) de doubles
Matriz matalloc(int n, int m) {
    int i;
    double **M;
    Matriz A;

    M    = malloc(n*sizeof(double*));
    M[0] = malloc(n*m*sizeof(double));
    for (i = 1; i < n; i++)
        M[i] = M[0] + i*m;

    A.n = n;
    A.m = m;
    A.M = M;
    return A;
}

void matfree(Matriz A) {
    free(A.M[0]);
    free(A.M);
}
