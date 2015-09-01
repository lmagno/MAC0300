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

Usando os arquivos de entrada padrões num Intel Core i5-4690K CPU @ 3.9GHz, obtém-se a saída\*

<table>
  <tr>
    <th></th>
    <th colspan="3">Colunas</th>
    <th></th>
    <th colspan="3">Linhas</th>
  </tr>
  <tr>
    <td>Nome do arquivo</td>
    <td>Cholesky</td>
    <td>Forward</td>
    <td>Back</td>
    <td></td>
    <td>Cholesky</td>
    <td>Forward</td>
    <td>Back</td>
  </tr>
  <tr>
    <td>Dados/a1.dat</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td></td>
    <td>0.00400</td>
    <td>0.00000</td>
    <td>0.00000</td>
  </tr>
  <tr>
    <td>Dados/a2.dat</td>
    <td>0.01200</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td></td>
    <td>0.01200</td>
    <td>0.00000</td>
    <td>0.00000</td>
  </tr>
  <tr>
    <td>Dados/a3.dat</td>
    <td>0.03600</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td></td>
    <td>0.04400</td>
    <td>0.00000</td>
    <td>0.00000</td>
  </tr>
  <tr>
    <td>Dados/a4.dat</td>
    <td>0.08400</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td></td>
    <td>0.10000</td>
    <td>0.00000</td>
    <td>0.00000</td>
  </tr>
  <tr>
    <td>Dados/a5.dat</td>
    <td>0.16400</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td></td>
    <td>0.19600</td>
    <td>0.00000</td>
    <td>0.00000</td>
  </tr>
  <tr>
    <td>Dados/a6.dat</td>
    <td>0.28400</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td></td>
    <td>0.33200</td>
    <td>0.00000</td>
    <td>0.00000</td>
  </tr>
  <tr>
    <td>Dados/a7.dat</td>
    <td>0.44800</td>
    <td>0.00000</td>
    <td>0.00000</td>
    <td></td>
    <td>0.56000</td>
    <td>0.00000</td>
    <td>0.00400</td>
  </tr>
  <tr>
    <td>Dados/a8.dat</td>
    <td colspan="7">A matriz não é definida positiva!</td>
  </tr>
  <tr>
    <td>Dados/a9.dat</td>
    <td colspan="7">A matriz não é definida positiva!</td>
  </tr>
</table>
\*_Os erros não estão sendo exibidos por questão de espaço._

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
