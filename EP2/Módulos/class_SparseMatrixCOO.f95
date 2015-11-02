module class_SparseMatrixCOO
    use class_SparseMatrixCSC
    implicit none
    private
    public :: SparseMatrixCOO


    type sp_t
        integer :: i, j
        real    :: v

        type(sp_t), pointer :: next => null()
    end type sp_t

    type SparseMatrixCOO
        integer    :: m, n
        integer    :: nnz
        type(sp_t), pointer :: data
    contains
        procedure :: print, allocate, deallocate, getindex, to_csc
    end type SparseMatrixCOO

contains
    ! Imprime os elementos não nulos da matriz para tela
    subroutine print(this)
        class(SparseMatrixCOO) :: this
        integer :: i, j
        real    :: v
        type(sp_t), pointer :: current

        print '("Matriz esparsa COO ", i0, "x", i0, " com ", i0, " valores não nulos: ")', this%m, this%n, this%nnz
        current => this%data
        do while (associated(current))
            i = current%i
            j = current%j
            v = current%v

            print '(4x, "[", i0, ", ", i0, "] = ", f10.6)', i, j, v
            current => current%next
        end do
        print *, ''
    end subroutine print

    ! Aloca uma matriz m×n esparsa com nnz elementos não-nulos no formato COO
    subroutine allocate(this, m, n, nnz, colind, rowind, val)
        class(SparseMatrixCOO), intent(inout) :: this
        integer,                intent(in)    :: m, n, nnz
        integer,                intent(in)    :: colind(:), rowind(:)
        real,                   intent(in)    :: val(:)

        integer :: k
        type(sp_t), pointer :: current, next

        this%m = m
        this%n = n
        this%nnz = nnz

        ! Aloca e grava o primeiro elemento
        allocate(this%data)
        current => this%data

        current%j = colind(1)
        current%i = rowind(1)
        current%v = val(1)

        do k = 2, nnz
            ! Aloca e grava o próximo elemento
            allocate(next)

            next%j = colind(k)
            next%i = rowind(k)
            next%v = val(k)

            ! Adiciona o elemento no final da lista e
            ! move para ele
            current%next => next
            current      => next
        end do
    end subroutine allocate

    ! Desaloca uma matriz esparsa no formato COO
    subroutine deallocate(this)
        class(SparseMatrixCOO) :: this
        type(sp_t), pointer    :: current, next

        current => this%data
        do while (associated(current))
            next => current%next

            deallocate(current)
            nullify(current)

            current => next
        end do
    end subroutine deallocate

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
        type(sp_t), pointer :: current

        v = 0.0
        if (i > this%m .or. j > this%n) then
            print '("ERRO: a matriz ", i0, "×", i0, " não contém o elemento [", i0, ", ", i0, "]")', this%m, this%n, i, j
            hasindex = -1
            return
        end if

        current => this%data
        do while (current%j <= j .and. current%i < i)
            current => current%next
        end do

        if (current%j == j .and. current%i == i) then
            hasindex = 1
            v = current%v
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
        type(sp_t), pointer :: current

        m   = this%m
        n   = this%n
        nnz = this%nnz

        call csc%allocate(m, n, nnz)


        current => this%data
        jold = 1
        csc%colptr(1) = 1
        do k = 1, nnz
            jnew = current%j
            if (jnew /= jold) then
                do j = jold+1, jnew-1
                    csc%colptr(j) = csc%colptr(jold)
                end do

                csc%colptr(jnew) = k
            end if
            jold = jnew
            csc%rowval(k) = current%i
            csc%nzval(k)  = current%v
            current => current%next
        end do

        do j = jold+1, n+1
            csc%colptr(j) = nnz+1
        end do
    end function to_csc
 end module class_SparseMatrixCOO
