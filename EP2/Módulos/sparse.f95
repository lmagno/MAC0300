module sparse
    implicit none

    ! Matrix esparsa m×n com coeficientes reais,
    ! armazenada no formato CSC (Compressed Sparse Column)
    type SparseMatrix
        integer :: m, n
        integer, pointer :: colptr(:), rowval(:)
        real,    pointer :: nzval(:)
    end type SparseMatrix

contains
    subroutine print(this)
        type(SparseMatrix) :: this
        integer :: n
        integer :: i, j, k
        real    :: v

        n = this%n
        do j = 1, n-1
            do k = this%colptr(j), this%colptr(j + 1) - 1
                i = this%rowval(k)
                v = this%nzval(k)

                print '(4x, "[", i0, ", ", i0, "] = ", f8.6)', i, j, v
            end do
        end do
    end subroutine print

    subroutine deallocate(this)
        type(SparseMatrix) :: this

        deallocate(this%colptr)
        deallocate(this%rowval)
        deallocate(this%nzval)
    end subroutine deallocate
end module sparse

program test
    use sparse
    implicit none
    integer :: i

    type (SparseMatrix) :: A
    A%m = 4
    A%n = 4
    allocate(A%colptr(5))
    allocate(A%rowval(4))
    allocate(A%nzval(4))
    A%colptr = [1, 2, 4, 5, 5]
    A%rowval = [2, 2, 4, 3]
    A%nzval =  [5, 8, 6, 3]

    call print(A)
    call deallocate(A)
end program test
