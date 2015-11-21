#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Decompõe uma matriz A (n×m) em uma matriz ortogonal Q (n×n) e uma
// triangular superior R (m×m) tal que
//     A = Q[R 0]ᵀ
void qr(double **A, int n, int m, int *p, double *gammas, int *posto) {
    int    i, j, k, maxind;
    double max, maxnorm, v, tau, gamma;
    double *norms, *w;
    double eps = 1e-15;

    w = malloc(m*sizeof(double));

    // Encontra o maior elemento de A
    max = 0.0;
    for (i = 0; i < n; i++){
        for (j = 0; j < m; j++) {
            v = fabs(A[i][j]);

            if (v > max)
                max = v;
        }
    }

    // Reescala toda a matriz A a fim de evitar overflow
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++)
            A[i][j] /= max;
    }

    // Calcula as normas (ao quadrado) das colunas de A
    norms = calloc(m, sizeof(double));
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            v = A[i][j];
            norms[j] += v*v;
        }
    }

    for (k = 0; k < m; k++) {
        // Calcula as normas das colunas da submatriz atual
        if (k > 0) {
            for (j = k; j < m; j++) {
                v = A[k-1][j];
                norms[j] -= v*v;
            }
        }

        // Acha a coluna com maior norma na submatriz atual
        maxnorm = norms[k];
        maxind  = k;
        for (j = k+1; j < m; j++) {
            v = norms[j];

            if (v > maxnorm) {
                maxind  = j;
                maxnorm = v;
            }
        }

        // Caso todas as colunas restantes tenham norma desprezível, a matriz
        // tem posto incompleto e não há mais o que fazer
        if (maxnorm < eps) {
            break;
        }

        // Permuta a coluna atual com a de maior norma (caso não seja a primeira)
        p[k] = maxind;
        if (maxind != k) {
            v = norms[k];
            norms[k] = norms[maxind];
            norms[maxind] = v;

            for (i = 0; i < n; i++) {
                v = A[i][k];
                A[i][k] = A[i][maxind];
                A[i][maxind] = v;
            }
        }

        ////////////////////////////////////////////////////////
        // Calcula o refletor para a primeira coluna (gamma e u)
        // Qₖ = I - γₖuₖuₖᵀ
        /////////////////////////////////////////////////////////

        // Escolhe o sinal de τ para evitar cancelamento catastrófico
        v   = A[k][k];
        tau = sqrt(norms[k]);
        if (v < 0)
            tau *= -1;

        // γ = (x₁ + τ)/τ
        v += tau;
        gamma = v/tau;
        gammas[k] = gamma;

        A[k][k] = -tau;
        // Normaliza u
        for (i = k+1; i < n; i++)
            A[i][k] /= v;

        /////////////////////////////////////////////////////
        // Aplica o refletor no restante da submatriz
        // A[k:n][k+1:m] ← (I - γₖuₖuₖᵀ)A[k:n][k+1:m]
        /////////////////////////////////////////////////////

        // wᵀ ← γₖuₖᵀA[k:n][k+1:m]
        for (j = k+1; j < m; j++)
            w[j] = gamma*A[k][j];

        for (i = k+1; i < n; i++) {
            v = gamma*A[i][k];
            for (j = k+1; j < m; j++)
                w[j] += v*A[i][j];
        }

        // A[k:n][k+1:m] ← A[k:n][k+1:m] - uₖwᵀ
        for (j = k+1; j < m; j++)
            A[k][j] -= w[j];

        for (i = k+1; i < n; i++) {
            v = A[i][k];
            for (j = k+1; j < m; j++)
                A[i][j] -= v*w[j];
        }
    }

    *posto = k;

    free(norms);
    free(w);
    return ;
}
