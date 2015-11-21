#include "Utils.h"

#ifndef STRUCT_QR_DEF
#define STRUCT_QR_DEF

typedef struct qr_t {
    int    *p;
    int    posto;
    double *gammas;
} QRFACT;
#endif

QRFACT qr(Matriz A);
void qrfree(QRFACT q);
