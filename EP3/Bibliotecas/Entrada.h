#include "Utils.h"

#ifndef STRUCT_SISTEMA_DEF
#define STRUCT_SISTEMA_DEF
typedef struct sistema_t {
    Matriz A;
    double *b;
} Sistema;

#endif

Sistema load(char *filename);
void sysfree(Sistema S);
