#include <stdio.h>
#include <stdlib.h>
#include "MMQ.h"

// Resolve o sistem S dado por
//     Ax = b
// a partir da decomposição QR q da matriz A de posto r tal que
//         ÂPP⁻¹x = b̂,    Â = A/max, b̂ = b\max
//         QRP⁻¹x = b̂
// Cuja solução é dada por
//          c = Qᵀb̂
//         Rx̂ = ĉ,        ĉ = c[0:r-1]
//          x = Px̂
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

    // Reescala o vetor b para manter o sistema equivalente
    for (i = 0; i < n; i++)
        b[i] /= max;

    // b̂ ← Qᵣ…Q₁b̂
    for (k = 0; k < r; k++) {
        // b̂ ← Qₖb̂
        // b̂[0:k-1] ← b̂[0:k-1]
        // b̂[k:n-1] ← b̂[k:n-1] - γₖuₖuₖᵀb̂[k:n-1]

        // v ← uₖᵀb̂[k:n-1]
        v = b[k];
        for (i = k+1; i < n; i++)
            v += M[i][k]*b[i];

        // b̂[k:n-1] ← b̂[k:n-1] - γₖuₖv
        gamma = gammas[k];
        b[k] -= gamma*v;
        for (i = k+1; i < n; i++)
            b[i] -= gamma*M[i][k]*v;

    }

    // Backsubstitution
    // Rx̂ = b̂[0:r-1]
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
