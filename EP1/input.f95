module Input
contains
    subroutine leSistema(n, A, b)
        integer, intent(out) :: n
        real*8, allocatable, intent(out) :: b(:)
        real*8, allocatable, intent(out) :: A(:, :)

        open(1, file = 'sistema', status = 'old')

        ! Lê o tamanho n do sistema e aloca a memória necessária
        read(1, *) n
        allocate(A(n, n))
        allocate(b(n))

        ! Lê a matriz A
        do k = 1, n*n
            read(1, *) i, j, A(i+1, j+1)
        end do

        ! Lê o vetor b
        do k = 1, n
            read(1, *) i, b(i+1)
        end do

        ! Já podemos fechar o arquivo de entrada
        close(1)
    end subroutine leSistema
end module Input
