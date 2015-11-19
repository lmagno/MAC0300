#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Bibliotecas/Entrada.h"
#include "Bibliotecas/Utils.h"

int main(int argc, char** argv) {
    double **A, *b;
    int n, m;

    load(&n, &m, &A, &b, "Dados/a1.dat");

    matfree(A, n);
    free(b);
    return 0;
}
