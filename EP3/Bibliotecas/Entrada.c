#include <stdio.h>
#include <stdlib.h>
#include "Entrada.h"

// Carrega a matriz A (n×m) e o vetor b (n) de um sistema Ax = b descrito
// no arquivo 'filename' e os retorna através dos ponteiros passados como
// argumentos.
Sistema loadsys(char *filename) {
    int    n, m;     // Número de linhas e colunas
    double **M, *b;  // Matriz e vetor
    int    i, j;
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
    fscanf(f, "%d %d", &n, &m);

    // Aloca a matriz e o vetor
    b = malloc(n*sizeof(double));
    A = matalloc(n, m);
    M = A.M;

    // Lê os elementos da matriz
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            fscanf(f, "%lf", &v);
            M[i][j] = v;
        }
    }

    // Lê os elementos do vetor
    for (i = 0; i < n; i++) {
        fscanf(f, "%lf", &v);
        b[i] = v;
    }

    S.A = A;
    S.b = b;

    fclose(f);
    return S;
}

// Gera um sistema Ax = b a partir de n pontos (t, b)
// descritos no arquivo filename e uma base dos polinômios de grau m-1
Sistema loaddata(char *filename) {
    int    n, m;         // Número de linhas e colunas
    double **M, *t, *b;  // Matriz e pontos (t, b)
    int    i, j;
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
    fscanf(f, "%d %d", &n, &m);

    // Aloca a matriz e os pontos (t, b)
    t = malloc(n*sizeof(double));
    b = malloc(n*sizeof(double));
    A = matalloc(n, m);
    M = A.M;

    // Lê os pontos (t, b)
    for (i = 0; i < n; i++)
        fscanf(f, "%lf %lf", &t[i], &b[i]);

    fclose(f);

    // Gera a matriz de Vandermonde de um polinômio
    // de grau m-1 nos tₙ pontos
    for (i = 0; i < n; i++) {
        M[i][0] = 1.0;
        v = t[i];
        for (j = 1; j < m; j++) {
            M[i][j] = M[i][j-1]*v;
        }
    }

    S.A = A;
    S.b = b;

    free(t);
    return S;
}

void sysfree(Sistema S) {
    matfree(S.A);
    free(S.b);
}
