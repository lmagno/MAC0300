#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Utils.h"
#include "Plot.h"

// Plota para um arquivo pdf os pontos definidos no arquivo
// input sobrepostos ao polinômio de coeficientes x, através
// de um pipe para o gnuplot
void plot(char *input, double *x) {
    int n, m;
    int i;
    double *t, *b;
    char *poly, *term, *output;
    FILE *f, *gnuplotPipe;

    f = fopen(input, "r");
    if (f == NULL) {
        printf("Não foi possível abrir o arquivo %s\n", input);
        return;
    }

    // Lê as dimensões do problema
    fscanf(f, "%d %d", &n, &m);

    t = malloc(n*sizeof(double));
    b = malloc(n*sizeof(double));

    // Lê os dados
    for (i = 0; i < n; i++)
        fscanf(f, "%lf %lf", &t[i], &b[i]);

    fclose(f);

    // Gera o polinômio a partir dos coeficientes
    term = malloc(50*sizeof(char));
    poly = malloc(m*50*sizeof(char));

    strcpy(poly, "");

    for (i = 0; i < m; i++) {
        sprintf(term, "+%.17e*x**%d", x[i], i);
        strcat(poly, term);
    }

    // Nomes do arquivo de saída e do título do gráfico
    output = chgext(input, ".pdf");

    // Abre um pipe para o gnuplot
    gnuplotPipe = popen("gnuplot", "w");

    fprintf(gnuplotPipe, "set xlabel 't'\n");
    fprintf(gnuplotPipe, "set ylabel 'b'\n");
    fprintf(gnuplotPipe, "set term pdfcairo size 10, 5\n");
    fprintf(gnuplotPipe, "set output '%s'\n", output);
    fprintf(gnuplotPipe, "plot '-' t 'dados', %s t 'x'\n", poly);
    for (i = 0; i < n; i++) {
        fprintf(gnuplotPipe, "%.17e %.17e\n", t[i], b[i]);
    }
    fprintf(gnuplotPipe, "e\n");

    free(t);
    free(b);
    free(term);
    free(poly);
    free(output);
}
