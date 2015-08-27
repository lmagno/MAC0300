program EP1
use matriz
use entrada
use cholesky
use trisys
implicit none
    integer :: n, s
    real, allocatable :: A(:, :), b(:)

    call le_sistema(n, A, b)    
    print *, "b"

    s = cholcol(n, A)
    s = backrow(n, A, b, .true.)
    print *, "b"
    call pvec(b)

    ! Desaloca a matriz A e o vetor b
    deallocate(b)
    deallocate(A)
end program EP1
