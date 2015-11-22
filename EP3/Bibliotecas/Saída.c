#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Utils.h"
#include "Saída.h"

void save(double *x, int m, char *input) {
    int i;
    char *output;
    FILE *f;

    output = chgext(input, ".out");

    f = fopen(output, "w");
    for (i = 0; i < m; i++) {
        fprintf(f, "%.17e\n", x[i]);
    }

    fclose(f);
    free(output);
}
