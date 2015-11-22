#include <stdio.h>
#include <stdlib.h>
#include "MMQ.h"

double* mmq(Sistema S, QR q) {
    Matriz A;
    int n, m;
    double **M, *b, *x;
    double gamma, *gammas, max;
    int *p, r;
    int i, j, k;
    double v;

    b = S.b;
    A = S.A;
    M = A.M;
    n = A.n;
    m = A.m;

    p      = q.p;
    r      = q.posto;
    max    = q.max;
    gammas = q.gammas;

    x = calloc(m, sizeof(double));

    // Sistema
    //         APP⁻¹x = b
    //         QRP⁻¹x = b
    // Solução
    //          c = Qᵀb
    //         Rx̂ = ĉ
    //          x = Px̂

    // Reescala o vetor b para manter o sistema equivalente
    for (i = 0; i < n; i++)
        b[i] /= max;

    // b ← Qᵣ…Q₁b
    for (k = 0; k < r; k++) {
        // b ← b - γₖuₖuₖᵀb

        // v ← uₖᵀb
        v = b[k];
        for (i = k+1; i < n; i++)
            v += M[i][k]*b[i];

        // b ← b - γₖuₖv
        gamma = gammas[k];
        b[k] -= gamma*v;
        for (i = k+1; i < n; i++)
            b[i] -= gamma*M[i][k]*v;

    }

    // Backsubstitution
    // Rx̂ = ĉ
    for (i = r-1; i >= 0; i--) {
        v = b[i];

        for (j = i+1; j < r; j++)
            v -= x[j]*M[i][j];

        x[i] = v/M[i][i];
    }

    // x = Px̂
    for (i = 0; i < r; i++) {
        k = p[i];

        v    = x[i];
        x[i] = x[k];
        x[k] = v;
    }

    return x;
}
