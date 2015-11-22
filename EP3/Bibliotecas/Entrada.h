#include "Utils.h"

#ifndef STRUCT_SISTEMA_DEF
#define STRUCT_SISTEMA_DEF
typedef struct sistema_t {
    Matriz A;
    double *b;
} Sistema;

#endif

Sistema loadsys(char *filename);
Sistema loaddata(char *filename);
void sysfree(Sistema S);
