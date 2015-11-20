using Polynomials

function main()
    n = 100
    m = 2

    # Gera um polinômio de grau m com coeficientes aleatórios c
    c = 10.^randn(m)
    p = Poly(c)

    # Gera um conjunto de pontos (x, y), onde y ≈ p(x)
    x = 10.^randn(n)
    y = polyval(p, x) + randn(n)

    # Cria a matriz de Vandermonde do sistema
    A = Array(Float64, (n, m))
    A[:, 1] = ones(n)
    for j = 2:m
        A[:, j] = A[:, j-1] .* x
    end

    # c̄ é a solução do sistema por mínimos quadrados e deve ser uma
    # aproximação de c
    c̄ = A\y

    file = open("sistema1.dat", "w")

    @printf file "%d %d\n" n m
    for i = 1:n
        for j = 1:m
            @printf file "%d %d %.17e\n" i-1 j-1 A[i, j]
        end
    end

    for i = 1:n
        @printf file "%d %.17e\n" i-1 y[i]
    end

    close(file)
end

main()
