#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Bibliotecas/Entrada.h"
#include "Bibliotecas/Utils.h"
#include "Bibliotecas/QR.h"

int main(int argc, char** argv) {
    double *b;
    double *gammas;
    int    *p, posto;
    Sistema S;
    Matriz  A;
    QRFACT  q;

    S = load("Dados/a1.dat");
    A = S.A;
    b = S.b;

    p      = malloc(A.m*sizeof(int));
    gammas = malloc(A.m*sizeof(double));

    q = qr(A);
    posto = q.posto;
    printf("%f\n", A.M[0][0]);
    printf("posto = %d\n", posto);


    sysfree(S);
    qrfree(q);
    return 0;
}
