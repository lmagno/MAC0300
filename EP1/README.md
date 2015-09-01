# Exercício Programa 1
## Parte 1
### Descrição
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

Usando os arquivos de entrada padrões num Intel(R) Atom(TM) CPU D2500 @ 1.86GHz, obtém-se a saída

```
                       Colunas                                       Linhas
Nome do arquivo       Cholesky   Forward      Back      Erro       Cholesky   Forward      Back      Erro
Dados/a1.dat           0.04670   0.00042   0.00050  3.17E-12        0.04726   0.00053   0.00072  3.17E-12
Dados/a2.dat           0.36486   0.00167   0.00200  8.84E-12        0.38081   0.00189   0.00171  8.84E-12
Dados/a3.dat           1.23721   0.00375   0.00449  1.22E-08        1.33745   0.00488   0.00406  1.22E-08
Dados/a4.dat           2.96058   0.00663   0.00809  4.13E-11        3.46062   0.00905   0.00811  4.13E-11
Dados/a5.dat           5.27848   0.00949   0.01122  9.65E-10        6.43529   0.01446   0.01361  9.65E-10
Dados/a6.dat           9.26094   0.01360   0.01643  1.81E-09       11.69809   0.02330   0.02210  1.81E-09
Dados/a7.dat          14.92115   0.01829   0.02227  1.29E-10       17.67135   0.02892   0.02748  1.29E-10
Dados/a8.dat         A matriz não é definida positiva!
Dados/a9.dat         A matriz não é definida positiva!
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
