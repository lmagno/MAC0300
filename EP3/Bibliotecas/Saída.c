#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Saída.h"

void save(double *x, int m, char *input) {
    int i;
    char *output, *p;
    FILE *f;

    output = malloc((strlen(input)+4)*sizeof(char));

    // Nome do arquivo de saída com extensão ".out", ignorando
    // a extensão do arquivo de entrada
    strcpy(output, input);
    p = strchr(output, '.');
    if(p == NULL)
        strcat(output, ".out");
    else
        strcpy(p, ".out");

    f = fopen(output, "w");
    for (i = 0; i < m; i++) {
        fprintf(f, "%.17e\n", x[i]);
    }

    fclose(f);
    free(output);
}
