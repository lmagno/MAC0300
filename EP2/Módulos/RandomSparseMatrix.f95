module RandomSparseMatrix
    use class_SparseMatrixCOO
    implicit none
    private
    public :: sprand
contains
    function sprand(n, tau) result(A)
        integer, intent(in) :: m, n
        real,    intent(in) :: tau

        type(SparseMatrixCOO) :: A, B

        integer :: i, j, k
        integer :: s, nnz
        real    :: v
        ! Aproximação de quantos elementos não-nulos haverão
        nnz = nint(2*tau*n**2)

        call A%allocate(m = n, n = n, nnz = nnz)

        k = 1
        do j = 1, n
            ! Parte triangular superior da matriz,
            ! onde os elementos já estão definidos devido à simetria.
            ! (Basta copiar o valor do elemento [j, i])
            do i = 1, j-1
                if (A%getindex(j, i, v) == 1) then
                    A%rowind(k) = i
                    A%colind(k) = j
                    A%val(k)    = v
                    k = k + 1
                end if
            end do

            ! Coloca 1's na diagonal principal
            A%rowind(k) = j
            A%colind(k) = j
            A%val(k)    = 1
            k = k + 1

            !
            do i = j+1, n
                ! v ∈ [-1, 1]
                v = 2*rand() - 1
                if (abs(v) < tau) then
                    A%rowind(k) = i
                    A%colind(k) = j
                    A%val(k)    = v
                    k = k + 1
                end if
            end do
        end do

        
    end function sprand
end module RandomSparseMatrix
