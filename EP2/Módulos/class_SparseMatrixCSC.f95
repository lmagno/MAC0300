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
        procedure :: print, summary, allocate, deallocate, times
    end type SparseMatrixCSC

contains
    ! Imprime os elementos não nulos da matriz para tela
    subroutine print(self)
        class(SparseMatrixCSC) :: self
        integer :: m, n, nnz
        integer :: i, j, k
        real    :: v

        m   = self%m
        n   = self%n
        nnz = self%nnz

        print '("Matriz esparsa CSC ", i0, "x", i0, " com ", i0, " valores não nulos: ")', m, n, nnz
        do j = 1, n
            do k = self%colptr(j), self%colptr(j + 1) - 1
                i = self%rowval(k)
                v = self%nzval(k)

                print '(4x, "[", i0, ", ", i0, "] = ", f10.6)', i, j, v
            end do
        end do
        print *, ''
    end subroutine print

    ! Similar ao print, mas não imprime os elementos em si.
    subroutine summary(self)
        class(SparseMatrixCSC), intent(in) :: self

        print '("Matriz esparsa CSC ", i0, "x", i0, " com ", i0, " valores não nulos.")', self%m, self%n, self%nnz
    end subroutine summary

    ! Aloca uma matriz m×n esparsa com nnz elementos não-nulos no formato CSC
    subroutine allocate(self, m, n, nnz)
        class(SparseMatrixCSC), intent(inout) :: self
        integer,                intent(in)    :: m, n, nnz

        self%m   = m
        self%n   = n
        self%nnz = nnz
        allocate(self%colptr(n+1))
        allocate(self%rowval(nnz))
        allocate(self%nzval(nnz))
    end subroutine allocate

    ! Desaloca uma matriz esparsa no formato CSC
    subroutine deallocate(self)
        class(SparseMatrixCSC) :: self

        deallocate(self%colptr)
        deallocate(self%rowval)
        deallocate(self%nzval)
    end subroutine deallocate

    ! Realiza a multiplicação self*B, onde self é uma matriz esparsa m×n e
    ! B é um vetor denso, gravando o resultado no vetor denso C,
    ! com eficiência O(n).
    ! Também verifica se as dimensões são compatíveis e imprime uma mensagem
    ! caso contrário.
    subroutine times(self, B, C)
        class(SparseMatrixCSC), intent(in)  :: self
        real,                   intent(in)  :: B(:)
        real,                   intent(out) :: C(:)

        integer :: m, n, nnz
        integer :: mB, mC
        integer :: i, j, k
        real    :: v

        m   = self%m
        n   = self%n
        nnz = self%nnz

        mB = size(B)
        mC = size(C)

        ! Verifica se as dimensões são compatíveis
        if (n /= mB) then
            print '("Dimensões incompatíveis no produto: ", i0, "×", i0, " * ", i0, "×", i0, " →  ", i0, "×", i0)', &
                    m, n, mB, 1, mC, 1
            return
        else if (m /= mC) then
            print '("Dimensões incompatíveis na atribuição: ", i0, "×", i0, " * ", i0, "×", i0, " →  ", i0, "×", i0)', &
                    m, n, mB, 1, mC, 1
            return
        end if

        ! Inicializa o vetor C
        do i = 1, mC
            C(i) = 0.0
        end do

        do j = 1, n
            do k = self%colptr(j), self%colptr(j + 1) - 1
                i = self%rowval(k)
                v = self%nzval(k)

                C(i) = C(i) + v*B(j)
            end do
        end do
    end subroutine times

end module class_SparseMatrixCSC
