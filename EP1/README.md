# Exercício Programa 1
## Parte 1 - Fator de Cholesky
A primeira parte do EP1 consiste em resolver diversos sistemas de equações lineares na forma

> **Ax** = **b**

com

> **A** ∈ ℝⁿˣⁿ  
> **x**, **b** ∈ ℝⁿ

através do fator de Cholesky **G** ∈ ℝⁿˣⁿ da matriz dos coeficientes,
que é calculado pelo método do produto externo.
Caso não seja possível calculá-lo (ou seja, a matriz não é definida positiva), a execução é
interrompida e um aviso é impresso.

Resumidamente, o sistema é resolvido em três passos:

1. Cálculo do fator de Cholesky: **A** = **GGᵀ**
2. *Forward substitution*: **Gy** = **b**
3. *Back substitution*: **Gᵀx** = **y**


_Nota: o fator de Cholesky **G** é gravado sobre a parte triangular inferior de **A** e os vetores **x** e **y** são guardados sobre **b** por economia de memória._

Esse processo é executado uma vez com orientação a colunas e uma vez com orientação a linhas, imprimindo os tempos de execução em segundos de cada passo, bem como o erro, definido como:

> Erro = ‖**xᵥ**-**x**‖/√n

onde **xᵥ** é a solução real do sistema, **x** é a solução calculada, n é o tamanho do vetor e ‖.‖ a norma euclidiana.

### Exemplo de saída

Usando os arquivos de entrada padrões num Intel(R) Core(TM) i5-4690K CPU @ 3.50GHz, obtém-se a saída

```
 ============================================= Cholesky =============================================
                      Colunas                                     Linhas
Nome do arquivo   Decomposição   Forward      Back    Erro   Decomposição   Forward      Back    Erro
Dados/a1.dat           0.00000   0.00000   0.00000  -11.50        0.00400   0.00000   0.00000  -11.50
Dados/a2.dat           0.00400   0.00000   0.00000  -11.05        0.00800   0.00000   0.00000  -11.05
Dados/a3.dat           0.01600   0.00000   0.00000   -7.91        0.02000   0.00000   0.00000   -7.91
Dados/a4.dat           0.04400   0.00000   0.00000  -10.38        0.04800   0.00000   0.00000  -10.38
Dados/a5.dat           0.08400   0.00000   0.00000   -9.02        0.09600   0.00000   0.00400   -9.02
Dados/a6.dat           0.14400   0.00000   0.00000   -8.74        0.16400   0.00000   0.00000   -8.74
Dados/a7.dat           0.22800   0.00000   0.00000   -9.89        0.26800   0.00000   0.00000   -9.89
Dados/a8.dat         A matriz não é definida positiva!
Dados/a9.dat         A matriz não é definida positiva!

 ================================================ LU ================================================
                      Colunas                                     Linhas
Nome do arquivo   Decomposição   Forward      Back    Erro   Decomposição   Forward      Back    Erro
Dados/m1.dat           0.00400   0.00000   0.00000  -13.37        0.00000   0.00000   0.00000  -13.37
Dados/m2.dat           0.00800   0.00000   0.00000  -13.31        0.01200   0.00000   0.00000  -13.31
Dados/m3.dat           0.03600   0.00000   0.00000  -12.27        0.04400   0.00000   0.00000  -12.27
Dados/m4.dat           0.08400   0.00000   0.00000  -12.88        0.10800   0.00000   0.00000  -12.86
Dados/m5.dat           0.16800   0.00000   0.00000  -11.45        0.21600   0.00000   0.00000  -11.45
Dados/m6.dat           0.28800   0.00000   0.00000  -11.73        0.37200   0.00000   0.00000  -11.73
Dados/m7.dat           0.45600   0.00000   0.00000  -11.93        0.63200   0.00000   0.00000  -11.93
Dados/m8.dat         A matriz é singular!
Dados/m9.dat         A matriz é singular!
```

### Modo de uso
Para compilar o programa, basta executar
```
make
```
nesta pasta, o que criará o executável `EP1.out` (a compilação depende do executável `f95`).

Se chamado na forma
```
EP1.out filename1 filename2 filename3 [...]
```
o programa usa cada arquivo como uma entrada diferente e resolve os respectivos sistemas.

Caso chamado sem argumentos, o programa utiliza os arquivos do exemplo acima como entrada.
