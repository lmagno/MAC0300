# Exercício Programa 1
## Parte 1
A primeira parte do EP1 consiste em resolver diversos sistemas de equações lineares na forma

> Ax = b

com

> A ∈ ℝⁿˣⁿ

> x, b ∈ ℝⁿ

através do fator de Cholesky *G* da matriz dos coeficientes, tal que

> A = GGᵀ

que é calculado pelo método do produto externo.
Caso não seja possível calculá-lo (ou seja, a matriz não é definida positiva), a execução é
interrompida e um aviso é impresso.

Uma vez calculado *G*, o sistema é resolvido em dois passos:

1. *Forward substitution*: Gy = b
2. *Backwards substitution*: Gᵀx = y
