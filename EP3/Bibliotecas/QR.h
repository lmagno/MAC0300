#include "Utils.h"

#ifndef STRUCT_QR_DEF
#define STRUCT_QR_DEF

typedef struct qr_t {
    int    *p;
    int    posto;
    double max;
    double *gammas;
} QR;
#endif

QR qr(Matriz A);
void qrfree(QR q);
