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
        procedure :: print, allocate, deallocate, reallocate, getindex, to_csc
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

    ! Realloca a matriz para uma nova com nnz elementos não-nulos,
    ! copiando o que for possível da matriz antiga.
    subroutine reallocate(this, nnz)
        class(SparseMatrixCOO), intent(inout) :: this
        integer,                intent(in)    :: nnz

        type(SparseMatrixCOO) :: C
        integer :: k
        call C%allocate(m = this%m, n = this%n, nnz = nnz)

        do k = 1, min(nnz, this%nnz)
            C%colind(k) = this%colind(k)
            C%rowind(k) = this%rowind(k)
            C%val(k)    = this%val(k)
        end do

        call this%deallocate
        this%colind => C%colind
        this%rowind => C%rowind
        this%val    => C%val
    end subroutine reallocate

    ! Busca o elemento [i, j] da matriz esparsa COO this e o grava em v
    ! caso exista.
    ! Retorna:
    !    -1: se o índice estiver fora dos limites da matriz
    !     0: se for um elemento nulo da matriz
    !     1: se for um elemento não nulo da matriz
    function getindex(this, i, j, v) result(hasindex)
        class(SparseMatrixCOO), intent(in)  :: this
        integer,                intent(in)  :: i, j
        real,                   intent(out) :: v

        integer :: hasindex
        integer :: k

        v = 0.0
        if (i > this%m .or. j > this%n) then
            print '("ERRO: a matriz ", i0, "×", i0, " não contém o elemento [", i0, ", ", i0, "]")', this%m, this%n, i, j
            hasindex = -1
            return
        end if

        k = 1
        do while (this%colind(k) <= j .and. this%rowind(k) < i)
            k = k + 1
        end do

        if (this%colind(k) == j .and. this%rowind(k) == i) then
            hasindex = 1
            v = this%val(k)
        else
            hasindex = 0
        end if
    end function

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
