module class_SparseMatrixCSC
    implicit none
    private
    public :: SparseMatrixCSC

    ! Matrix esparsa m×n com coeficientes reais,
    ! armazenada no formato CSC (Compressed Sparse Column)
    type SparseMatrixCSC
        integer :: m, n, nnz
        integer, pointer :: colptr(:), rowval(:)
        real,    pointer :: nzval(:)
    contains
        procedure :: print, allocate, deallocate
    end type SparseMatrixCSC

contains
    ! Imprime os elementos não nulos da matriz para tela
    subroutine print(this)
        class(SparseMatrixCSC) :: this
        integer :: m, n, nnz
        integer :: i, j, k
        real    :: v

        m   = this%m
        n   = this%n
        nnz = this%nnz

        print '("Matriz esparsa CSC ", i0, "x", i0, " com ", i0, " valores não nulos: ")', m, n, nnz
        do j = 1, n
            do k = this%colptr(j), this%colptr(j + 1) - 1
                i = this%rowval(k)
                v = this%nzval(k)

                print '(4x, "[", i0, ", ", i0, "] = ", f10.6)', i, j, v
            end do
        end do
        print *, ''
    end subroutine print

    ! Aloca uma matriz m×n esparsa com nnz elementos não-nulos no formato CSC
    subroutine allocate(this, m, n, nnz)
        class(SparseMatrixCSC), intent(inout) :: this
        integer,                intent(in)    :: m, n, nnz

        this%m   = m
        this%n   = n
        this%nnz = nnz
        allocate(this%colptr(n+1))
        allocate(this%rowval(nnz))
        allocate(this%nzval(nnz))
    end subroutine allocate

    ! Desaloca uma matriz esparsa no formato CSC
    subroutine deallocate(this)
        class(SparseMatrixCSC) :: this

        deallocate(this%colptr)
        deallocate(this%rowval)
        deallocate(this%nzval)
    end subroutine deallocate

end module class_SparseMatrixCSC

module class_SparseMatrixCOO
    use class_SparseMatrixCSC
    implicit none
    private
    public :: SparseMatrixCOO
    type SparseMatrixCOO
        integer :: m, n
        integer :: nnz
        integer, pointer :: colind(:), rowind(:)
        real,    pointer :: val(:)

    contains
        procedure :: print, allocate, deallocate, to_csc
    end type SparseMatrixCOO

contains
    ! Imprime os elementos não nulos da matriz para tela
    subroutine print(this)
        class(SparseMatrixCOO) :: this
        integer :: i, j, k
        real    :: v

        print '("Matriz esparsa COO ", i0, "x", i0, " com ", i0, " valores não nulos: ")', this%m, this%n, this%nnz
        do k = 1, this%nnz
            i = this%rowind(k)
            j = this%colind(k)
            v = this%val(k)

            print '(4x, "[", i0, ", ", i0, "] = ", f10.6)', i, j, v
        end do
        print *, ''
    end subroutine print

    ! Aloca uma matriz m×n esparsa com nnz elementos não-nulos no formato COO
    subroutine allocate(this, m, n, nnz)
        class(SparseMatrixCOO), intent(inout) :: this
        integer,                intent(in)    :: m, n, nnz

        this%m = m
        this%n = n
        this%nnz = nnz
        allocate(this%colind(nnz))
        allocate(this%rowind(nnz))
        allocate(this%val(nnz))
    end subroutine allocate

    ! Desaloca uma matriz esparsa no formato COO
    subroutine deallocate(this)
        class(SparseMatrixCOO) :: this

        deallocate(this%colind)
        deallocate(this%rowind)
        deallocate(this%val)
    end subroutine deallocate

    ! Cria uma matriz esparsa no formato CSC a partir de uma
    ! no formato COO
    function to_csc(this) result(csc)
        class(SparseMatrixCOO) :: this
        type(SparseMatrixCSC)  :: csc
        integer :: m, n, nnz
        integer :: j, k, jold, jnew

        m   = this%m
        n   = this%n
        nnz = this%nnz

        call csc%allocate(m, n, nnz)
        csc%rowval = this%rowind
        csc%nzval  = this%val

        csc%colptr(1) = 1

        jold = 1
        do k = 1, nnz
            jnew = this%colind(k)
            if (jnew /= jold) then
                do j = jold+1, jnew-1
                    csc%colptr(j) = csc%colptr(jold)
                end do

                csc%colptr(jnew) = k
            end if
            jold = jnew
        end do

        do j = jold+1, n+1
            csc%colptr(j) = nnz+1
        end do
    end function to_csc
end module class_SparseMatrixCOO

program test
    use class_SparseMatrixCSC
    use class_SparseMatrixCOO
    implicit none
    integer :: i

    type(SparseMatrixCSC) :: A
    type(SparseMatrixCOO) :: B

    call B%allocate(m = 4, n = 4, nnz = 4)
    B%colind = [1, 2, 2, 3]
    B%rowind = [2, 2, 4, 3]
    B%val    = [5, 8, 6, 3]

    call B%print

    A = B%to_csc()
    call A%print

    call A%deallocate
    call B%deallocate

    call B%allocate(m = 5, n = 7, nnz = 9)
    B%colind = [1,   2,  2,  3,  3,  4,  5,  6,  7]
    B%rowind = [1,   1,  2,  2,  3,  3,  3,  4,  5]
    B%val    = [11, 22, 33, 44, 55, 66, 77, 88, 99]

    call B%print

    A = B%to_csc()
    call A%print

    call A%deallocate
    call B%deallocate

    call B%allocate(m = 10, n = 1, nnz = 2)
    B%colind = [1,  1]
    B%rowind = [1, 10]
    B%val    = [1,  1]

    call B%print
    A = B%to_csc()
    call A%print
    call A%deallocate
    call B%deallocate

end program test
