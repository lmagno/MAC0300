module RandomSparseMatrix
    use class_SparseMatrixCOO
    implicit none
    private
    public :: sprand
contains
    function sprand(n, tau) result(A)
        integer, intent(in) :: n
        real,    intent(in) :: tau

        type(SparseMatrixCOO) :: A

        integer :: i, j
        integer :: hasindex
        real    :: v

        call A%init(n, n)

        do j = 1, n
            ! Parte triangular superior da matriz,
            ! onde os elementos já estão definidos devido à simetria.
            ! (Basta copiar o valor do elemento [j, i])
            do i = 1, j-1
                if (A%getindex(j, i, v) == 1) then
                    hasindex = A%setindex(i, j, v)
                end if
            end do

            ! Coloca 1's na diagonal principal
            hasindex = A%setindex(j, j, 1.0)

            !
            do i = j+1, n
                ! v ∈ [-1, 1]
                v = 2*rand() - 1
                if (abs(v) < tau) then
                    hasindex = A%setindex(i, j, v)
                end if
            end do
        end do

    end function sprand
end module RandomSparseMatrix
