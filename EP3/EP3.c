#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Bibliotecas/Entrada.h"
#include "Bibliotecas/Utils.h"
#include "Bibliotecas/QR.h"

int main(int argc, char** argv) {
    double **A, *b;
    double *gammas;
    int    *p, posto;
    int n, m;

    p      = malloc(m*sizeof(int));
    gammas = malloc(m*sizeof(double));

    load(&n, &m, &A, &b, "Dados/sistema1.dat");
    qr(A, n, m, p, gammas, &posto);

    printf("posto = %d\n", posto);
    matfree(A);
    free(b);
    return 0;
}
