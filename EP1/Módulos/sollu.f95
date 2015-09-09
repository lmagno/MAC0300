module sollu
use lu, only: lucol
use matriz, only: pmatriz, pvec
use entrada, only: le_sistema
implicit none
contains
    function sollucol(filename) result(status)
        character(len=*), intent(in) :: filename
        integer :: n, status
           real, allocatable :: A(:, :)
           real, allocatable :: x(:), b(:)
        integer, allocatable :: p(:)

        call le_sistema(n, A, b, filename)
        allocate(x(n))
        allocate(p(n))

        status = lucol(n, A, p)

        deallocate(A)
        deallocate(b)
        deallocate(x)
        deallocate(p)
    end function sollucol
end module sollu
