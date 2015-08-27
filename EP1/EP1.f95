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

    s = cholrow(n, A)
    s = forwcol(n, A, b)
    print *, "b"
    call pvec(b)

    ! Desaloca a matriz A e o vetor b
    deallocate(b)
    deallocate(A)
end program EP1
