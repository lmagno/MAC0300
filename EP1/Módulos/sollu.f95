module sollu
use      lu, only: lucol, lurow, sscol, ssrow
use   utils, only: pmatriz, pvec, swap, Results
use entrada, only: le_sistema
implicit none
contains
    function sollucol(filename, res) result(status)
        character(len=*), intent(in)  :: filename
          type (Results), intent(out) :: res
           real, allocatable :: A(:, :)
           real, allocatable :: x(:), b(:)
        integer, allocatable :: p(:)
        integer :: i, n, status
           real :: start, finish

        call le_sistema(n, A, b, filename)
        allocate(p(n))

        call cpu_time(start)
        status = lucol(n, A, p)
        call cpu_time(finish)
        res%tdecomp = finish - start

        
        if (status == -1) then
           return
        end if

        status = sscol(n, A, p, b, res)
        if (status == -1) then
           return
        end if

        ! Aloca e calcula o vetor solução esperado
        allocate(x(n))
        x = [(1 + mod(i-1, n/100), i = 1, n)]

        ! Calcula a norma do vetor diferença
        ! entre a solução esperada e a obtida,
        ! como forma de estimativa do erro
        res%erro = norm2(x - b)/sqrt(real(n))

        deallocate(A)
        deallocate(b)
        deallocate(x)
        deallocate(p)
    end function sollucol

    function sollurow(filename, res) result(status)
        character(len=*), intent(in)  :: filename
          type (Results), intent(out) :: res
           real, allocatable :: A(:, :)
           real, allocatable :: x(:), b(:)
        integer, allocatable :: p(:)
        integer :: i, n, status
           real :: start, finish

        call le_sistema(n, A, b, filename)
        allocate(p(n))

        call cpu_time(start)
        status = lurow(n, A, p)
        call cpu_time(finish)
        res%tdecomp = finish - start
        if (status == -1) then
           return
        end if

        status = ssrow(n, A, p, b, res)
        if (status == -1) then
           return
        end if

        ! Aloca e calcula o vetor solução esperado
        allocate(x(n))
        x = [(1 + mod(i-1, n/100), i = 1, n)]

        ! Calcula a norma do vetor diferença
        ! entre a solução esperada e a obtida,
        ! como forma de estimativa do erro
        res%erro = norm2(x - b)/sqrt(real(n))

        deallocate(A)
        deallocate(b)
        deallocate(x)
        deallocate(p)
    end function sollurow
end module sollu
