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
Nome do arquivo       Cholesky   Forward  Backward      Erro       Cholesky   Forward  Backward      Erro
Dados/a1.dat           0.03178   0.00027   0.00032  3.17E-11        0.03195   0.00035   0.00028  3.17E-11
Dados/a2.dat           0.25150   0.00111   0.00140  1.25E-10        0.25891   0.00152   0.00118  1.25E-10
Dados/a3.dat           0.85829   0.00260   0.00297  2.12E-07        0.95939   0.00353   0.00316  2.12E-07
Dados/a4.dat           2.03287   0.00469   0.00543  8.25E-10        2.39481   0.00678   0.00638  8.25E-10
Dados/a5.dat           3.96805   0.00707   0.00859  2.16E-08        4.75033   0.01091   0.01015  2.16E-08
Dados/a6.dat           6.82770   0.01028   0.01239  4.43E-08        8.31521   0.01581   0.01502  4.43E-08
Dados/a7.dat          10.82939   0.01379   0.01658  3.40E-09       13.22789   0.02212   0.02074  3.40E-09
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
