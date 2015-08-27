program EP1
use matriz,   only: pvec
use entrada,  only: le_sistema
use cholesky, only: cholcol, cholrow
use trisys,   only: forwcol, forwrow, backcol, backrow
implicit none
    integer :: n, s
    real, allocatable :: A(:, :), b(:)
    character(len=72) :: filename

    call get_command_argument(1, filename)
    print *, filename
    call le_sistema(n, A, b, filename)    

    s = cholrow(n, A)
    s = forwcol(n, A, b)
    print *, "b"
    call pvec(b)

    ! Desaloca a matriz A e o vetor b
    deallocate(b)
    deallocate(A)
end program EP1
