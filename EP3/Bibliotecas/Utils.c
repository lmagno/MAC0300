#include <stdio.h>
#include <stdlib.h>

// Aloca uma matriz A (n×m) de doubles
double** matalloc(int n, int m) {
    int i;
    double **A;

    A    = malloc(n*sizeof(double*));
    A[0] = malloc(n*m*sizeof(double));
    for (i = 1; i < n; i++)
        A[i] = A[0] + i*m;

    return A;
}

void matfree(double **A) {
    free(A[0]);
    free(A);
}
