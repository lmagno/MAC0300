program EP1
use entrada
use cholesky
use trisys
implicit none
    integer :: n, s
    real, allocatable :: A(:, :), b(:)

    call le_sistema(n, A, b)    
    print *, b
    s = cholcol(n, A)
    print *, s
    
    s = forwrow(n, A, b)
    print *, b

    ! Desaloca a matriz A e o vetor b
    deallocate(b)
    deallocate(A)
end program EP1
