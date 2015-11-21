#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Bibliotecas/Entrada.h"
#include "Bibliotecas/Utils.h"
#include "Bibliotecas/QR.h"
int main(int argc, char** argv) {
    double **A, *b;
    int n, m;

    load(&n, &m, &A, &b, "Dados/sistema1.dat");
    qr(A, n, m);

    matfree(A, n);
    free(b);
    return 0;
}
