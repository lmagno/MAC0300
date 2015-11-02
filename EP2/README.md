# Exercício Programa 2
## Métodos iterativos para sistemas lineares: Gradientes Conjugados

Este EP consiste em implementar a resolução de sistemas lineares na forma

> **Ax** = **b**

onde

> **A** ∈ ℝⁿˣⁿ, definida positiva e esparsa  
> **x**, **b** ∈ ℝⁿ densos

através do método de Gradientes Conjugados.

### Motivação
Por que utilizar matrizes esparsas?
A necessidade de matrizes esparsas fica mais clara quando se lida com matrizes gigantes,
de forma que armanezar a matriz toda na memória não é uma possibilidade. No entanto,
em diversas aplicações (diferenças finitas para resolução de equações diferenciais, por exemplo)
surgem matrizes bem estruturadas, com apenas alguns elementos não-nulos. Assim, guardando
apenas estes elementos, se torna possível manipular matrizes ordens de grandezas maiores
do que caberia na memória de um computador.

Por outro lado, embora economizem muita memória dependendo da densidade de elementos
não nulos, geralmente o acesso aos elementos de uma matriz esparsa é muito mais caro do que aos
de uma densa (que é O(1)), já que estes são armazenados utilizando estruturas que não
permitem o acesso direto a um elemento (como uma lista ligada). Este acesso pode ser
feito barato, a custo da eficiência de se iterar sobre as linhas ou colunas da matriz,
sendo difícil conciliar o desempenho dessas duas operações.

Por esses motivos, os métodos padrões de resolução de sistemas lineares (LU, Cholesky)
não são eficazes para matrizes esparsas, pois além de acessarem diretamente elementos
da matriz, também podem estragar sua esparsidade ao decompô-la em outras matrizes.

É aí que entra o método de Gradientes Conjugados, uma vez que ele depende somente do
produto matriz-vetor entre a matriz esparsa e vetores densos, o que pode ser feito
eficaz facilmente, escolhendo uma estrutura adequada. Além disso, como não altera
a matriz original, nem a decompõe em novas, não altera sua esparsidade, mantendo
a eficiência de seu uso.

### Matrizes Esparsas
Há diversas implementações comuns de matrizes esparsas, com suas vantagens e desvantagens,
mas aqui vamos focar nas duas utilizadas neste EP.

#### Coordinate List (COO)
É uma forma simples de matriz esparsa, composta por uma cadeia ordenada de tuplas na forma
(linha, coluna, valor). Neste trabalho foi implementada utilizando uma lista ligada,
tornando simples a inserção de elementos novos mantendo a ordenação escolhida (por colunas
e então por linhas).
Entretanto, obter uma coluna específica de uma matriz neste formato não é muito eficiente,
então ele foi utilizado somente para construção da matriz esparsa e então traduzido
para um formato mais adequado.

#### Compressed Sparse Column (CSC)
Mais complexo do que o formato COO, o CSC é composto principalmente por três vetores

* **nzval**: contém os valores de todos os elementos não-nulos, ordenados por
coluna e então por linha
* **rowval**: contém os valores dos índices de linha de cada elemento correspondente em **nzval**
* **colptr**: contém os índices de **nzval** em que se encontram os primeiros elementos de cada coluna da matriz. Por exemplo, `nzval(colptr(j))` representa
o valor do primeiro elemento da coluna `j` na matriz.

Vale notar que **nzval** e **rowval** são obtidos diretamente a partir de uma matriz no formato COO, sendo necessário apenas o cálculo de **colptr**.
A vantagem de se utilizar este formato está na facilidade de se obter uma coluna da matriz (a coluna `j` são os elementos em `nzval` entre `colptr(j)` e `colptr(j+1)-1`), o que torna barato o produto matriz-vetor orientado a colunas.

### Gradientes Conjugados
