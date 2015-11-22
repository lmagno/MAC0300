using Polynomials

function main()
    n = parse(Int, ARGS[1])
    m = parse(Int, ARGS[2])

    # Gera um polinômio de grau m com coeficientes aleatórios c
    c = 100*randn(m)
    p = Poly(c)

    # Gera um conjunto de pontos (x, y), onde y ≈ p(x)
    x = 100*randn(n)
    y = polyval(p, x).*(1 + 0.1*randn(n))

    # Cria a matriz de Vandermonde do sistema
    A = Array(Float64, (n, m))
    A[:, 1] = ones(n)
    for j = 2:m
        A[:, j] = A[:, j-1] .* x
    end

    dados = open("dados1.dat", "w")

    @printf dados "%d %d\n" n m
    for i = 1:n
        @printf dados "%.17e %.17e\n" x[i] y[i]
    end

    close(dados)

    sistema = open("sistema1.dat", "w")

    @printf sistema "%d %d\n" n m
    for i = 1:n
        for j = 1:m
            @printf sistema "%.17e\n" A[i, j]
        end
    end

    for i = 1:n
        @printf sistema "%.17e\n" y[i]
    end

    close(sistema)

    solução = open("solução1.dat", "w");

    # c̄ é a solução do sistema por mínimos quadrados e deve ser uma
    # aproximação de c
    c̄ = A\y

    for i = 1:m
        @printf solução "%.17e\n" c̄[i]
    end

    close(solução)
end

main()
