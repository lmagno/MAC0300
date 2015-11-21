#include <stdio.h>
#include <stdlib.h>
#include "Entrada.h"

// Carrega a matriz A (n×m) e o vetor b (n) de um sistema Ax = b descrito
// no arquivo 'filename' e os retorna através dos ponteiros passados como
// argumentos.
Sistema load(char *filename) {
    int    l, c;     // Número de linhas e colunas
    double **M, *d;  // Matriz e vetor
    int    i, j, k;
    double v;
    FILE   *f;
    Sistema S;
    Matriz  A;

    // Tenta abrir o arquivo
    f = fopen(filename, "r");
    if (f == NULL) {
        printf("Não foi possível abrir o arquivo %s\n", filename);
        return S;
    }

    // Lê as dimensões do sistema
    fscanf(f, "%d %d", &l, &c);

    // Aloca a matriz e o vetor
    d = malloc(l*sizeof(double));
    A = matalloc(l, c);
    M = A.M;

    // Lê os elementos da matriz
    for (k = 0; k < l*c; k++) {
        fscanf(f, "%d %d %lf", &i, &j, &v);
        M[i][j] = v;
    }

    // Lê os elementos do vetor
    for (k = 0; k < c; k++) {
        fscanf(f, "%d %lf", &i, &v);
        d[i] = v;
    }

    S.A = A;
    S.b = d;

    fclose(f);
    return S;
}

void sysfree(Sistema S) {
    matfree(S.A);
    free(S.b);
}
