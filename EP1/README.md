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

> Erro = |**xᵥ**-**x**|  

onde **xᵥ** é a solução real do sistema e **x** é a calculada.

### Exemplo de saída

Usando os arquivos de entrada padrões num Intel(R) Atom(TM) CPU D2500 @ 1.86GHz, obtém-se a saída

```
                       Colunas                                       Linhas
Nome do arquivo       Cholesky   Forward      Back      Erro       Cholesky   Forward      Back      Erro
Dados/a1.dat           0.03151   0.00028   0.00033  3.17E-11        0.03235   0.00035   0.00028  3.17E-11
Dados/a2.dat           0.25203   0.00119   0.00135  1.25E-10        0.25872   0.00146   0.00118  1.25E-10
Dados/a3.dat           0.85019   0.00255   0.00307  2.12E-07        0.96115   0.00365   0.00318  2.12E-07
Dados/a4.dat           2.01717   0.00450   0.00542  8.25E-10        2.37813   0.00678   0.00635  8.25E-10
Dados/a5.dat           3.94505   0.00700   0.00865  2.16E-08        4.73860   0.01094   0.01028  2.16E-08
Dados/a6.dat           6.81735   0.01013   0.01221  4.43E-08        8.29661   0.01618   0.01540  4.43E-08
Dados/a7.dat          10.85767   0.01379   0.01668  3.40E-09       13.17556   0.02156   0.02071  3.40E-09
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
