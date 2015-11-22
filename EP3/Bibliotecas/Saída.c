#include <stdio.h>
#include <stdlib.h>
#include "Saída.h"

void save(double *x, int m) {
    int i;
    FILE *f;

    f = fopen("output", "w");
    for (i = 0; i < m; i++) {
        fprintf(f, "%.17e\n", x[i]);
    }

    fclose(f);
}
