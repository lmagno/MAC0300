#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void qr(double **A, int n, int m) {
    int    i, j, k, maxind;
    double max, maxnorm, v, tau, gamma;
    double *norms, *gammas, *w;
    int    *P;

    gammas = malloc(m*sizeof(double));
    w      = malloc(m*sizeof(double));

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

    P = malloc(m*sizeof(int));
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

        // Permuta a coluna atual com a de maior norma (caso não seja a primeira)
        P[k] = maxind;
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

    printf("\nR\n");
    for (i = 0; i < m; i++) {
        for (j = 0; j < i; j++)
            printf("0.000000\t");

        for (j = i; j < m; j++)
            printf("%f\t", max*A[i][j]);

        printf("\n");
    }
    free(P);
    free(norms);
    free(gammas);
    free(w);
}
