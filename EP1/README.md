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

> Erro = ‖**xᵥ**-**x**‖/n

onde **xᵥ** é a solução real do sistema e **x** é a calculada.

### Exemplo de saída

Usando os arquivos de entrada padrões num Intel(R) Atom(TM) CPU D2500 @ 1.86GHz, obtém-se a saída

```
                       Colunas                                       Linhas
Nome do arquivo       Cholesky   Forward      Back      Erro       Cholesky   Forward      Back      Erro
Dados/a1.dat           0.03166   0.00043   0.00033  3.17E-13        0.03159   0.00038   0.00029  3.17E-13
Dados/a2.dat           0.25193   0.00114   0.00136  6.25E-13        0.26093   0.00145   0.00117  6.25E-13
Dados/a3.dat           0.84770   0.00255   0.00304  7.06E-10        0.94658   0.00358   0.00307  7.06E-10
Dados/a4.dat           2.01504   0.00449   0.00543  2.06E-12        2.37540   0.00676   0.00624  2.06E-12
Dados/a5.dat           3.94789   0.00701   0.00851  4.31E-11        4.73853   0.01087   0.01024  4.31E-11
Dados/a6.dat           6.80976   0.01013   0.01221  7.38E-11        8.28356   0.01581   0.01591  7.38E-11
Dados/a7.dat          10.84991   0.01369   0.01669  4.86E-12       13.18766   0.02167   0.02094  4.86E-12
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
