#!/usr/bin/julia
function main()
    n = int(ARGS[1])
    @assert n  > 0 "O tamanho do sistema deve ser positivo!"

    M = rand(1:10, (n, n))
    A = M'*M
    G = chol(A)'
    b = rand(1:10, n)
    x = A\b
    y = G\b
    open("sistema", "w") do f
        write(f, "$(n)\n")
        for j = 1:n, i = 1:n
            write(f, @sprintf "%d %d %e\n" i-1 j-1 A[i, j])
        end

        for i = 1:n
            write(f, @sprintf "%d %.6e\n" i-1 b[i])
        end
    end

    open("solução", "w") do f
        write(f, "Fator de Cholesky:\n")
        for i = 1:n
            for j = 1:n
                write(f, @sprintf "%.4f " G[i, j])
            end
            write(f, @sprintf "\n")
        end

        write(f, "Gy = b\n")
        writedlm(f, y)

        write(f, "Ax = b\n")
        writedlm(f, x)
    end
end

main()
