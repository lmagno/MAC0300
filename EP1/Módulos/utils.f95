! Módulo com algumas utilidades para matrizes/vetores
module utils
    implicit none

    type Results
        sequence
        real :: erro
        real :: tdecomp, tforw, tback
    end type Results

contains
    ! Imprime um vetor em formato de coluna
    subroutine pvec(v)
        real, intent(in) :: v(:)

        integer :: n, i

        n = size(v)

        do i = 1, n
            print *, v(i)
        end do
    end subroutine pvec

    ! Imprime uma matriz
    subroutine pmatriz(A)
        real, intent(in) :: A(:, :)

        integer :: s(2), i

        s = shape(A)

        do i = 1, s(1)
            print *, A(i, :)
        end do
    end subroutine pmatriz

    subroutine swap(a, b)
        real, intent(inout) :: a, b

        real :: tmp

        tmp = a
        a = b
        b = tmp
    end subroutine swap

end module utils
