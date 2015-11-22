#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "Bibliotecas/Entrada.h"
#include "Bibliotecas/Utils.h"
#include "Bibliotecas/QR.h"
#include "Bibliotecas/MMQ.h"
#include "Bibliotecas/Saída.h"
#include "Bibliotecas/Plot.h"

int main(int argc, char** argv) {
    Sistema S;
    Matriz  A;
    QR      q;
    double *x;
    char   *type, *input;
    int i;

    // Determina onde começam os argumentos de verdade
    i = 0;
    while(!strcmp("EP3", argv[i]))
        i++;

    type  = argv[i];    // Tipo de entrada (sistema já montado ou dados)
    input = argv[i+1];  // Nome do arquivo de entrada

    // Carrega o sistema (A e b) do arquivo de entrada
    if (!strcmp("sys", type))
        S = loadsys(input);
    else if(!strcmp("data", type))
        S = loaddata(input);
    else {
        fprintf(stderr, "Tipo de entrada '%s' não reconhecido.\n", type);
        return 1;
    }

    A = S.A;

    // Decompõe A por QR
    q = qr(A);

    // Resolve o sistema por mínimos quadrados utilizando a
    // decomposição QR de A
    x = mmq(S, q);

    // Salva o resultado para um arquivo de saída
    save(x, A.m, input);
    plot(input, x);

    // Libera as memórias alocadas
    free(x);
    sysfree(S);
    qrfree(q);
    return 0;
}
