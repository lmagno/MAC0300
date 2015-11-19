#include <stdio.h>
#include <stdlib.h>
#include "Utils.h"

// Carrega a matriz A (n×m) e o vetor b (n) de um sistema Ax = b descrito
// no arquivo 'filename' e os retorna através dos ponteiros passados como
// argumentos.
void load(int *n, int *m, double ***A, double **b, char *filename) {
    int    l, c;     // Número de linhas e colunas
    double **C, *d;  // Matriz e vetor
    int    i, j, k;
    double v;
    FILE   *f;

    // Tenta abrir o arquivo
    f = fopen(filename, "r");
    if (f == NULL) {
        printf("Não foi possível abrir o arquivo %s\n", filename);
        return;
    }

    // Lê as dimensões do sistema
    fscanf(f, "%d %d", &l, &c);

    // Aloca a matriz e o vetor
    C = matalloc(l, c);
    d = malloc(  l*sizeof(double));

    // Lê os elementos da matriz
    for (k = 0; k < l*c; k++) {
        fscanf(f, "%d %d %lf", &i, &j, &v);
        C[i][j] = v;
    }

    // Lê os elementos do vetor
    for (k = 0; k < c; k++) {
        fscanf(f, "%d %lf", &i, &v);
        d[i] = v;
    }

    // "Retorna" os dados nos ponteiros passados
    *n = l;
    *m = c;
    *A = C;
    *b = d;

    fclose(f);
    return ;
}
