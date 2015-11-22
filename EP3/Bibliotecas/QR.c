#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "QR.h"

// Decompõe uma matriz A (n×m) em uma matriz ortogonal Q (n×n) e uma
//  R (n×m) tal que
//     ÂP = QR̂
// onde
//     Â = A/max, max é o maior elemento em módulo de A
//     P é uma matriz de permutação
//     Q = Q₁…Qᵣ produto de refletores de Hausdorff
//     R̂ = ⎡R₁₁ R₁₂⎤, R₁₁ (r×r) triangular superior não-singular
//         ⎣ 0  0 ⎦
//
// e R̂ é armazenada sobre a parte triangular superior da matriz A.
// Cada refletor de Hausdorff é da forma
//     Qk = ⎡Iₖ-₁     0   ⎤, uₖ (n-k)
//          ⎣ 0  Iₖ-γₖuₖuₖᵀ⎦
// Os γₖ são armazenados num vetor separado, enquanto que os uₖ são
// gravados na parte triangular inferior de A (o primeiro elemento
// de uₖ é sempre 1, então não precisa ser armazedado).
//
// Além disso, retorna
//     - max, o elemento máximo de A usado para reescalar e evitar overflow
//     - o posto de A
//     - o vetor p de permutações das colunas de A
QR qr(Matriz A) {
    int    n, m;
    double **M;
    int    i, j, k, maxind;
    double max, maxnorm, v, tau, gamma;
    double *norms, *w;
    double eps = 1e-15;
    QR q;
    int *p;
    double *gammas;

    n = A.n;
    m = A.m;
    M = A.M;

    p      = malloc(m*sizeof(int));
    gammas = malloc(m*sizeof(double));
    w      = malloc(m*sizeof(double));

    // Encontra o maior elemento de A
    max = 0.0;
    for (i = 0; i < n; i++){
        for (j = 0; j < m; j++) {
            v = fabs(M[i][j]);

            if (v > max)
                max = v;
        }
    }

    // Reescala toda a matriz A a fim de evitar overflow
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++)
            M[i][j] /= max;
    }

    // Calcula as normas (ao quadrado) das colunas de A
    norms = calloc(m, sizeof(double));
    for (i = 0; i < n; i++) {
        for (j = 0; j < m; j++) {
            v = M[i][j];
            norms[j] += v*v;
        }
    }

    for (k = 0; k < m; k++) {
        // Calcula as normas das colunas da submatriz atual
        if (k > 0) {
            for (j = k; j < m; j++) {
                v = M[k-1][j];
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
                v = M[i][k];
                M[i][k] = M[i][maxind];
                M[i][maxind] = v;
            }
        }

        ////////////////////////////////////////////////////////
        // Calcula o refletor para a primeira coluna (gamma e u)
        // Qₖ = I - γₖuₖuₖᵀ
        /////////////////////////////////////////////////////////

        // Escolhe o sinal de τ para evitar cancelamento catastrófico
        v   = M[k][k];
        tau = sqrt(norms[k]);
        if (v < 0)
            tau *= -1;

        // γ = (x₁ + τ)/τ
        v += tau;
        gamma = v/tau;
        gammas[k] = gamma;

        M[k][k] = -tau;
        // Normaliza u
        for (i = k+1; i < n; i++)
            M[i][k] /= v;

        /////////////////////////////////////////////////////
        // Aplica o refletor no restante da submatriz
        // A[k:n][k+1:m] ← (I - γₖuₖuₖᵀ)A[k:n][k+1:m]
        /////////////////////////////////////////////////////

        // wᵀ ← γₖuₖᵀA[k:n][k+1:m]
        for (j = k+1; j < m; j++)
            w[j] = gamma*M[k][j];

        for (i = k+1; i < n; i++) {
            v = gamma*M[i][k];
            for (j = k+1; j < m; j++)
                w[j] += v*M[i][j];
        }

        // A[k:n][k+1:m] ← A[k:n][k+1:m] - uₖwᵀ
        for (j = k+1; j < m; j++)
            M[k][j] -= w[j];

        for (i = k+1; i < n; i++) {
            v = M[i][k];
            for (j = k+1; j < m; j++)
                M[i][j] -= v*w[j];
        }
    }

    q.posto  = k;
    q.p      = p;
    q.max    = max;
    q.gammas = gammas;

    free(norms);
    free(w);
    return q;
}

void qrfree(QR q) {
    free(q.p);
    free(q.gammas);
}
