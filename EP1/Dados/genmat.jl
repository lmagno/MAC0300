#!/usr/bin/julia
function ok()
    print_with_color(:green, " OK\n")
end

function main()
    n = int(ARGS[1])
    @assert n  > 0 "O tamanho do sistema deve ser positivo!"

    print("Criando M...")
    M = rand(1:10, (n, n))
    ok()

    print("Calculando A = MᵀM...")
    A = M'*M
    ok()

    print("Calculando o fator de Cholesky de A...")
    G = chol(A)'
    ok()

    print("Criando b...")
    b = rand(1:10, n)
    ok()

    print("Calculando Ax = b...")
    x = A\b
    ok()

    print("Calculando Gy = b...")
    y = G\b
    ok()

    print("Escrevendo para o arquivo 'sistema'...")
    open("sistema", "w") do f
        write(f, "$(n)\n")
        for j = 1:n, i = 1:n
  	    @inbounds write(f, @sprintf "%d %d %e\n" i-1 j-1 A[i, j])
        end

        for i = 1:n
            @inbounds write(f, @sprintf "%d %.6e\n" i-1 b[i])
        end
    end
    ok()

    print("Escrevendo para o arquivo 'solução'...")
    open("solução", "w") do f
        write(f, "Fator de Cholesky:\n")
        for i = 1:n
            for j = 1:n
                @inbounds write(f, @sprintf "%.4f " G[i, j])
            end
            write(f, @sprintf "\n")
        end

        write(f, "Gy = b\n")
        writedlm(f, y)

        write(f, "G'y = b\n")
        writedlm(f, G'\b)

        write(f, "Ax = b\n")
        writedlm(f, x)
        
    end
    ok()
end

main()
