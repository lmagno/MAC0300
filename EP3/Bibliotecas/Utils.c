#include <stdio.h>
#include <stdlib.h>

// Aloca uma matriz A (n×m) de doubles
double** matalloc(int n, int m) {
    int i;
    double **C;

    C = malloc(n*sizeof(double*));

    for (i = 0; i < n; i++)
        C[i] = malloc(m*sizeof(double));

    return C;
}

void matfree(double **A, int n) {
    int i;

    for (i = 0; i < n; i++)
        free(A[i]);

    free(A);
}
