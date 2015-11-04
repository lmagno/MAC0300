module class_SparseMatrixCOO
    use class_SparseMatrixCSC
    implicit none
    private
    public :: SparseMatrixCOO

    ! Nó da lista ligada
    type sp_t
        integer :: i, j
        real    :: v

        type(sp_t), pointer :: next => null()
    end type sp_t

    ! Matriz esparsa no formato COO (Coordinate List) utilizando lista ligada
    ! para os elementos, para facilitar a manipulação destes
    type SparseMatrixCOO
        integer    :: m, n
        integer    :: nnz
        type(sp_t), pointer :: first => null()
    contains
        procedure :: init, print, summary, &
                     allocate, deallocate, &
                     getindex, setindex, &
                     to_csc, full
    end type SparseMatrixCOO

contains

    ! Inicializa uma matriz vazia
    subroutine init(self, m, n)
        class(SparseMatrixCOO), intent(inout) :: self
        integer,                intent(in)    :: m, n

        self%m   = m
        self%n   = n
        self%nnz = 0
    end subroutine init

    ! Imprime os elementos não nulos da matriz para tela
    subroutine print(self)
        class(SparseMatrixCOO) :: self
        integer :: i, j
        real    :: v
        type(sp_t), pointer :: current

        print '("Matriz esparsa COO ", i0, "x", i0, " com ", i0, " valores não nulos: ")', self%m, self%n, self%nnz
        current => self%first
        do while (associated(current))
            i = current%i
            j = current%j
            v = current%v

            print '(4x, "[", i0, ", ", i0, "] = ", f10.6)', i, j, v
            current => current%next
        end do
        print *, ''
    end subroutine print

    ! Similar ao print, mas não imprime os elementos em si.
    subroutine summary(self)
        class(SparseMatrixCOO), intent(in) :: self

        print '("Matriz esparsa COO ", i0, "x", i0, " com ", i0, " valores não nulos.")', self%m, self%n, self%nnz
    end subroutine summary

    ! Grava a matriz esparsa como densa em A
    subroutine full(self, A)
        class(SparseMatrixCOO), intent(in)  :: self
        real,                   intent(out) :: A(:, :)

        type(sp_t), pointer :: current

        A(:, :) = 0.0
        current => self%first
        do while (associated(current))
            A(current%i, current%j) = current%v

            current => current%next
        end do
    end subroutine full

    ! Aloca uma matriz m×n esparsa com nnz elementos não-nulos no formato COO
    subroutine allocate(self, m, n, nnz, colind, rowind, val)
        class(SparseMatrixCOO), intent(inout) :: self
        integer,                intent(in)    :: m, n, nnz
        integer,                intent(in)    :: colind(:), rowind(:)
        real,                   intent(in)    :: val(:)

        integer :: k
        type(sp_t), pointer :: current, next

        self%m = m
        self%n = n
        self%nnz = nnz

        ! Aloca e grava o primeiro elemento
        allocate(self%first)
        current => self%first

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
    subroutine deallocate(self)
        class(SparseMatrixCOO) :: self
        type(sp_t), pointer    :: current, next

        current => self%first
        do while (associated(current))
            next => current%next

            deallocate(current)
            nullify(current)

            current => next
        end do
    end subroutine deallocate

    ! Busca o elemento [i, j] da matriz esparsa COO self e o grava em v
    ! caso exista.
    ! Retorna:
    !    -1: se o índice estiver fora dos limites da matriz
    !     0: se for um elemento nulo da matriz
    !     1: se for um elemento não nulo da matriz
    function getindex(self, i, j, v) result(hasindex)
        class(SparseMatrixCOO), intent(in)  :: self
        integer,                intent(in)  :: i, j
        real,                   intent(out) :: v

        integer :: hasindex
        type(sp_t), pointer :: current

        v = 0.0
        if (i > self%m .or. j > self%n) then
            print '("ERRO: a matriz ", i0, "×", i0, " não contém o elemento [", i0, ", ", i0, "]")', self%m, self%n, i, j
            hasindex = -1
            return
        end if

        current => self%first

        if (.not. associated(current)) then
            hasindex = 0
            return
        end if

        do while (associated(current%next) .and. current%j <= j .and. current%i < i)
            current => current%next
        end do

        if (current%j == j .and. current%i == i) then
            hasindex = 1
            v = current%v
        else
            hasindex = 0
        end if
    end function

    ! Grava o valor v no elemento [i, j] da matriz.
    ! Retorna:
    !    -1: se o índice estiver fora dos limites da matriz
    !     0: se for um elemento nulo da matriz
    !     1: se for um elemento não nulo da matriz
    function setindex(self, i, j, v) result(hasindex)
        class(SparseMatrixCOO), intent(inout) :: self
        integer,                intent(in)    :: i, j
        real,                   intent(in)    :: v

        integer :: hasindex
        type(sp_t), pointer :: current, next

        if (i > self%m .or. j > self%n) then
            print '("ERRO: a matriz ", i0, "×", i0, " não contém o elemento [", i0, ", ", i0, "]")', self%m, self%n, i, j
            hasindex = -1
            return
        end if

        current => self%first
        ! Se a matriz não tiver nenhum elemento não nulo,
        ! grava na primeira posição
        if (.not. associated(current)) then
            allocate(next)
            next%i = i
            next%j = j
            next%v = v

            self%first => next
            self%nnz = self%nnz + 1
            hasindex = 0
            return
        end if


        if (current%i > i .and. current%j > j) then
            allocate(next)
            next%i = i
            next%j = j
            next%v = v

            next%next  => self%first
            self%first => next
            self%nnz = self%nnz + 1
            hasindex = 0
            return
        end if

        ! Itera a lista até achar a posição em que o elemento [i, j]
        ! deveria estar
        next => current%next
        do while (associated(next) .and. next%j < j)
            current => next
            next    => next%next
        end do

        do while(associated(next) .and. next%j == j .and. next%i <= i)
            current => next
            next    => next%next
        end do

        ! Verifica se o elemento já existe na lista e altera seu valor
        ! ou insere um novo elemento nesta posição
        if (current%j == j .and. current%i == i) then
            current%v = v
            hasindex = 1
        else
            allocate(next)
            next%i = i
            next%j = j
            next%v = v

            self%nnz = self%nnz + 1
            next%next => current%next
            current%next => next
            hasindex = 0
        end if
    end function setindex

    ! Cria uma matriz esparsa no formato CSC a partir de uma
    ! no formato COO
    function to_csc(self) result(csc)
        class(SparseMatrixCOO) :: self
        type(SparseMatrixCSC)  :: csc

        integer :: m, n, nnz
        integer :: j, k, jold, jnew
        type(sp_t), pointer :: current

        m   = self%m
        n   = self%n
        nnz = self%nnz

        call csc%allocate(m, n, nnz)

        current => self%first
        jold = 1
        csc%colptr(1) = 1
        do k = 1, nnz
            jnew = current%j
            if (jnew /= jold) then
                do j = jold+1, jnew
                    csc%colptr(j) = k
                end do

                jold = jnew
            end if

            csc%rowval(k) = current%i
            csc%nzval(k)  = current%v
            current => current%next
        end do

        do j = jnew+1, n+1
            csc%colptr(j) = nnz+1
        end do
    end function to_csc
 end module class_SparseMatrixCOO
