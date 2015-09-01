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


*Nota: o fator de Cholesky **G** é gravado sobre a parte triangular inferior de **A** e os vetores **x** e **y** são guardados sobre **b** por economia de memória.*

Esse processo é executado uma vez com orientação a colunas e uma vez com orientação a linhas, imprimindo os tempos de execução em segundos de cada passo, bem como o erro, definido como:

> Erro = |**xᵥ**-**x**|  

onde **xᵥ** é a solução real do sistema e **x** é a calculada.
### Exemplo de saída
Usando os arquivos de entrada padrões num Intel Core i5-4690K CPU @ 3.9GHz, obtém-se a saída

|                 | Colunas                           |         |          |          |   | Linhas   |         |          |          |
|-----------------|-----------------------------------|---------|----------|----------|---|----------|---------|----------|----------|
| Nome do arquivo | Cholesky                          | Forward | Backward | Erro     |   | Cholesky | Forward | Backward | Erro     |
| Dados/a1.dat    | 0.00000                           | 0.00000 | 0.00000  | 3.17E-11 |   | 0.00400  | 0.00000 | 0.00000  | 3.17E-11 |
| Dados/a2.dat    | 0.01200                           | 0.00000 | 0.00000  | 1.25E-10 |   | 0.01200  | 0.00000 | 0.00000  | 1.25E-10 |
| Dados/a3.dat    | 0.03600                           | 0.00000 | 0.00000  | 2.12E-07 |   | 0.04400  | 0.00000 | 0.00000  | 2.12E-07 |
| Dados/a4.dat    | 0.08400                           | 0.00000 | 0.00000  | 8.25E-10 |   | 0.10000  | 0.00000 | 0.00000  | 8.25E-10 |
| Dados/a5.dat    | 0.16400                           | 0.00000 | 0.00000  | 2.16E-08 |   | 0.19600  | 0.00000 | 0.00000  | 2.16E-08 |
| Dados/a6.dat    | 0.28400                           | 0.00000 | 0.00000  | 4.43E-08 |   | 0.33200  | 0.00000 | 0.00000  | 4.43E-08 |
| Dados/a7.dat    | 0.44800                           | 0.00000 | 0.00000  | 3.40E-09 |   | 0.56000  | 0.00000 | 0.00400  | 3.40E-09 |
| Dados/a8.dat    | A matriz não é definida positiva! |         |          |          |   |          |         |          |          |
| Dados/a9.dat    | A matriz não é definida positiva! |         |          |          |   |          |         |          |          |

### Modo de uso
