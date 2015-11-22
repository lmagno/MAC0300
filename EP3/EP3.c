#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "Bibliotecas/Entrada.h"
#include "Bibliotecas/Utils.h"
#include "Bibliotecas/QR.h"
#include "Bibliotecas/MMQ.h"
#include "Bibliotecas/Saída.h"

int main(int argc, char** argv) {
    Sistema S;
    Matriz  A;
    QR      q;
    double *x;
    char   *input;
    int i;

    // Escolhe o primeiro argumento como nome do arquivo
    // de entrada
    i = 0;
    while(!strcmp("EP3", argv[i]))
        i++;

    input = argv[i];
    // Carrega o sistema (A e b) do arquivo de entrada
    S = loaddata(input);
    A = S.A;

    // Decompõe A por QR
    q = qr(A);

    // Resolve o sistema por mínimos quadrados utilizando a
    // decomposição QR de A
    x = mmq(S, q);

    // Salva o resultado para um arquivo de saída
    save(x, A.m, input);

    // Libera as memórias alocadas
    free(x);
    sysfree(S);
    qrfree(q);
    return 0;
}
