module exemplos
    use class_SparseMatrixCSC
    use class_SparseMatrixCOO
    use RandomSparseMatrix
    use CG,       only: solve_cg
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
        real    :: tau
        real    :: sprand, to_csc, CG, full, Cholesky, diff
    contains
        procedure :: print, string, total
    end type res_t

contains

    ! Imprime os resultados de forma organizada
    subroutine print(self)
        class(res_t) :: self
        if (self%cg_only) then
            print '(i5, f6.3, 3f10.4)', self%n, self%tau, self%sprand, self%to_csc, self%CG
        else
            print '(i5, f6.3, 5f10.4, e10.2, l10)', self%n, self%tau, self%sprand, self%to_csc, self%CG, &
                                               self%full, self%Cholesky, self%diff, self%posdef
        end if
    end subroutine

    ! Retorn os resultados numa string de forma organizada
    function string(self) result(results)
        class(res_t) :: self

        character(len=100) :: results
        if (self%cg_only) then
            write (results, '(i5, f6.3, 3f10.4)'), self%n, self%tau, self%sprand, self%to_csc, self%CG
        else
            write (results, '(i5, f6.3, 5f10.4, e10.2, l10)'), self%n, self%tau, self%sprand, self%to_csc, self%CG, &
                                               self%full, self%Cholesky, self%diff, self%posdef
        end if
    end function
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
    function ex_cg(n, tau) result(res)
        integer, intent(in)  :: n
        real,    intent(out) :: tau

        type(SparseMatrixCSC) :: A_cg
        type(SparseMatrixCOO) :: tmp
        real, allocatable :: b(:), x_cg(:)

        integer*8 :: start, finish, cr, cm
        character(len=64) :: filename
        real :: rate
        type(res_t) :: res

        write(filename, '(A, i0, "_", f4.2)'), "Exemplos/", n, tau
        call system_clock(count_rate = cr, count_max = cm)
        rate = real(cr)
        call random_seed()

        res%cg_only = .true.
        res%n = n
        res%tau = tau
        allocate(b(n))
        allocate(x_cg(n))

        ! Gera a matriz aleatória
        call system_clock(start)
        tmp = sprand(n, tau)
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
        call solve_cg(A_cg, b, x_cg, filename)
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
    function ex_cg_chol(n, tau) result(res)
        integer, intent(in)  :: n
        real,    intent(out) :: tau

        type(SparseMatrixCSC) :: A_cg
        type(SparseMatrixCOO) :: tmp
        real, allocatable :: b(:), x_chol(:), x_cg(:), A_chol(:, :)

        character(len=32) :: filename
        integer*8 :: start, finish, cr, cm
        real :: rate
        type(res_t) :: res

        write(filename, '(A, i0, "_", f4.2)'), "Exemplos/", n, tau
        call system_clock(count_rate = cr, count_max = cm)
        rate = real(cr)
        call random_seed()

        res%cg_only = .false.
        res%n = n
        res%tau = tau
        allocate(b(n))
        allocate(x_cg(n))
        allocate(x_chol(n))
        allocate(A_chol(n, n))

        ! Gera a matriz aleatória
        call system_clock(start)
        tmp = sprand(n, tau)
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
        call solve_cg(A_cg, b, x_cg, filename)
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
