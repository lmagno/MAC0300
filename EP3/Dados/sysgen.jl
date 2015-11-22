using Polynomials

function main()
    n = 20
    m = 4

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
            @printf file "%.17e\n" A[i, j]
        end
    end

    for i = 1:n
        @printf file "%.17e\n" y[i]
    end

    close(file)

    file = open("solução1.dat", "w");
    F = qrfact(A, Val{true})
    ĉ = F[:Q]'y

    @printf file "F\n"
    writedlm(file, F.factors)

    @printf file "\nR\n"
    writedlm(file, F[:R])

    @printf file "\np\n"
    writedlm(file, F[:p])

    @printf file "\nc̄\n"
    writedlm(file, c̄)

    @printf file "\nĉ\n"
    writedlm(file, ĉ)


    close(file)
end

main()
