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

<table>
  <tr>
    <th></th>
    <th colspan="4">Colunas</th>
    <th></th>
    <th colspan="4">Linhas</th>
  </tr>
  <tr>
    <td>Nome do arquivo</td>
    <td>Cholesky</td>
    <td>Forward</td>
    <td>Backward</td>
    <td>Erro</td>
    <td></td>
    <td>Cholesky</td>
    <td>Forward</td>
    <td>Backward</td>
    <td>Erro</td>
  </tr>
  <tr>
    <td>Dados/a1.dat</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>3.17E-11</td>
    <td></td>
    <td>0.00400</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>3.17E-11</td>
  </tr>
  <tr>
    <td>Dados/a2.dat</td>
    <td>0.01200</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>1.25E-10</td>
    <td></td>
    <td>0.01200</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>1.25E-10</td>
  </tr>
  <tr>
    <td>Dados/a3.dat</td>
    <td>0.03600</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>2.12E-07</td>
    <td></td>
    <td>0.04400</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>2.12E-07</td>
  </tr>
  <tr>
    <td>Dados/a4.dat</td>
    <td>0.08400</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>8.25E-10</td>
    <td></td>
    <td>0.10000</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>8.25E-10</td>
  </tr>
  <tr>
    <td>Dados/a5.dat</td>
    <td>0.16400</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>2.16E-08</td>
    <td></td>
    <td>0.19600</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>2.16E-08</td>
  </tr>
  <tr>
    <td>Dados/a6.dat</td>
    <td>0.28400</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>4.43E-08</td>
    <td></td>
    <td>0.33200</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>4.43E-08</td>
  </tr>
  <tr>
    <td>Dados/a7.dat</td>
    <td>0.44800</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>3.40E-09</td>
    <td></td>
    <td>0.56000</td>
    <td>0.00000</td>
    <td>0.00400</td>
    <td>3.40E-09</td>
  </tr>
  <tr>
    <td>Dados/a8.dat</td>
    <td colspan="9">A matriz não é definida positiva!</td>
  </tr>
  <tr>
    <td>Dados/a9.dat</td>
    <td colspan="9">A matriz não é definida positiva!</td>
  </tr>
</table>

### Modo de uso
