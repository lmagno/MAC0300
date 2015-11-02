module exemplos
    use class_SparseMatrixCSC
    use class_SparseMatrixCOO
    use RandomSparseMatrix
    use CG
    use cholesky, only: cholcol
    use trisys,   only: forwcol, backcol
    implicit none
    private
    public :: res_t, ex_cg_chol, ex_cg

    ! Tipo para poder retornar vários resultados
    type res_t
        integer :: n
        logical :: cg_only
        logical :: posdef
        real    :: sprand, to_csc, CG, full, Cholesky, diff
    contains
        procedure :: print, total
    end type res_t

contains

    ! Imprime os resultados de forma organizada
    subroutine print(self)
        class(res_t) :: self
        if (self%cg_only) then
            print '(i5, 3f10.4)', self%n, self%sprand, self%to_csc, self%CG
        else
            print '(i5, 5f10.4, e10.2, l10)', self%n, self%sprand, self%to_csc, self%CG, &
                                               self%full, self%Cholesky, self%diff, self%posdef
        end if
    end subroutine

    ! Retorna o tempo total de execução daquele exemplo
    ! (a soma de todos os passos)
    function total(self) result(t)
        class(res_t) :: self
        real         :: t

        t = self%sprand
        t = t + self%to_csc
        t = t + self%CG

        if (.not. self%cg_only) then
            t = t + self%full
            t = t + self%Cholesky
        end if
    end function total

    ! Gera um sistema aleatório com matriz de coeficientes n×n esparsa
    ! e o resolve usando o método de gradientes conjugados,
    ! retornando os tempos de cada passo da resolução
    function ex_cg(n) result(res)
        integer, intent(in) :: n

        type(SparseMatrixCSC) :: A_cg
        type(SparseMatrixCOO) :: tmp
        real, allocatable :: b(:), x_cg(:)
        integer*8 :: start, finish, cr, cm
        real :: rate
        type(res_t) :: res

        call system_clock(count_rate = cr, count_max = cm)
        rate = real(cr)
        call random_seed()

        res%cg_only = .true.
        res%n = n
        allocate(b(n))
        allocate(x_cg(n))

        ! Gera a matriz aleatória
        call system_clock(start)
        tmp = sprand(n, 0.01)
        call system_clock(finish)

        res%sprand = (finish-start)/rate

        ! Gera o vetor de soluções aleatório
        call random_number(b)

        ! Converte a matriz esparsa para CSC
        call system_clock(start)
        A_cg = tmp%to_csc()
        call system_clock(finish)
        res%to_csc = (finish-start)/rate

        ! Resolve por gradientes conjugados
        call system_clock(start)
        call solve(A_cg, b, x_cg)
        call system_clock(finish)
        res%CG = (finish-start)/rate


        call tmp%deallocate
        call A_cg%deallocate
        deallocate(b)
        deallocate(x_cg)
    end function ex_cg

    ! Gera um sistema aleatório com matriz de coeficientes n×n esparsa
    ! e o resolve usando o método de gradientes conjugados e por Cholesky,
    ! retornando os tempos de cada passo, a diferença entre os resultados
    ! obtidos por cada método e se a matriz era definida positiva mesmo.
    function ex_cg_chol(n) result(res)
        integer, intent(in) :: n

        type(SparseMatrixCSC) :: A_cg
        type(SparseMatrixCOO) :: tmp
        real, allocatable :: b(:), x_chol(:), x_cg(:), A_chol(:, :)
        integer*8 :: start, finish, cr, cm
        real :: rate
        type(res_t) :: res

        call system_clock(count_rate = cr, count_max = cm)
        rate = real(cr)
        call random_seed()

        res%cg_only = .false.
        res%n = n
        allocate(b(n))
        allocate(x_cg(n))
        allocate(x_chol(n))
        allocate(A_chol(n, n))

        ! Gera a matriz aleatória
        call system_clock(start)
        tmp = sprand(n, 0.01)
        call system_clock(finish)

        res%sprand = (finish-start)/rate

        ! Gera o vetor de soluções aleatório
        call random_number(b)
        x_chol = b

        ! Converte a matriz esparsa para CSC
        call system_clock(start)
        A_cg = tmp%to_csc()
        call system_clock(finish)
        res%to_csc = (finish-start)/rate

        ! Resolve por gradientes conjugados
        call system_clock(start)
        call solve(A_cg, b, x_cg)
        call system_clock(finish)
        res%CG = (finish-start)/rate

        ! Converte a matriz esparsa para densa
        call system_clock(start)
        call tmp%full(A_chol)
        call system_clock(finish)
        res%full = (finish-start)/rate

        ! Resolve por Cholesky
        call system_clock(start)
        res%posdef = cholcol(n, A_chol) == 0 .and. &
                     forwcol(n, A_chol, x_chol, unit = .false.) == 0 .and. &
                     backcol(n, A_chol, x_chol, trans = .true.) == 0
        call system_clock(finish)
        res%Cholesky = (finish-start)/rate

        ! Norma da diferença entre as soluções
        res%diff = dot_product(x_chol - x_cg, x_chol - x_cg)

        call tmp%deallocate
        call A_cg%deallocate
        deallocate(b)
        deallocate(x_chol)
        deallocate(x_cg)
        deallocate(A_chol)
    end function ex_cg_chol
end module exemplos
