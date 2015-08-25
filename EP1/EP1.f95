program EP1
use entrada
use cholesky
implicit none
    integer :: n, i, j, k
    real,  allocatable :: A(:, :), b(:)


    call le_sistema(n, A, b)
    k = cholcol(n, A)
    print *, k
    print *, kind(1.0)

    ! Desaloca a matriz A e o vetor b
    deallocate(b)
    deallocate(A)
end program EP1
