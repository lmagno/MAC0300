#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv) {
    int n, m, i;
    double x[3] = {-1, 2, 3};
    char *poly, *term;

    term = malloc(40*sizeof(char));
    poly = malloc(3*40*sizeof(char));
    strcpy(poly, "");

    sprintf(term, "%.17e", x[0]);
    strcat(poly, term);

    sprintf(term, "+%.17e*x", x[1]);
    strcat(poly, term);

    for (i = 2; i < 3; i++) {
        sprintf(term, "+%.17e*x**%d", x[i], i);
        strcat(poly, term);
    }
    printf("%s\n", poly);

    FILE *gnuplotPipe = popen("gnuplot", "w");
    fprintf(gnuplotPipe, "set term pdfcairo size 10, 5\n");
    fprintf(gnuplotPipe, "set output 'teste.pdf'\n");
    fprintf(gnuplotPipe, "plot %s t 'poly'\n", poly);

    return 0;
}
