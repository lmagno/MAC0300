#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Bibliotecas/Entrada.h"
#include "Bibliotecas/Utils.h"
#include "Bibliotecas/QR.h"
#include "Bibliotecas/MMQ.h"

int main(int argc, char** argv) {
    Sistema S;
    Matriz  A;
    QR      q;
    double *b;
    int i;

    S = load("Dados/sistema1.dat");
    A = S.A;
    b = S.b;

    printf("\nb\n");
    for (i = 0; i < A.n; i++)
        printf("%d %f\n", i, b[i]);

    q = qr(A);
    mmq(S, q);

    sysfree(S);
    qrfree(q);
    return 0;
}
