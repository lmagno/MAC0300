program EP1
    use    utils, only: pvec, Results
    use   sol_lu, only: sol_lu_col,   sol_lu_row
    use sol_chol, only: sol_chol_col, sol_chol_row
    implicit none

    integer                        :: i, n
    character(len=72)              :: filename
    character(len=72), allocatable :: chol_filenames(:), lu_filenames(:)

    n = IARGC()

    ! Usa arquivos padrões caso nenhum seja passado
    ! como argumento
    if (n == 0) then
        n = 9
        allocate(chol_filenames(n))
        allocate(  lu_filenames(n))

        open(1, file = "cholesky_defaults", status = "old")
        open(2, file =       "lu_defaults", status = "old")

        ! Arquivos de entrada padrões
        do i = 1, n
            read (1, '(a)'), chol_filenames(i)
            read (2, '(a)'),   lu_filenames(i)
        end do

        close(1)
        close(2)
    else
        ! Arquivos passados como argumentos
        allocate(chol_filenames(n))
        allocate(  lu_filenames(n))

        do i = 1, n
            call get_command_argument(i, filename)
            chol_filenames(i) = filename
              lu_filenames(i) = filename
        end do
    end if

    print *, "============================================= Cholesky ============================================="
    call solve_systems(chol_filenames, sol_chol_col, sol_chol_row, "A matriz não é definida positiva!")

    print *, ""
    print *, "================================================ LU ================================================"
    call solve_systems(lu_filenames, sol_lu_col, sol_lu_row, "A matriz é singular!")

    deallocate(chol_filenames)
    deallocate(  lu_filenames)

contains
  subroutine solve_systems(filenames, sol_col, sol_row, errmsg)
    ! Dummies
    character(len=*), intent(inout) :: filenames(:)
    character(len=*), intent(in)    :: errmsg
    integer                         :: sol_col, sol_row

    ! Locais
    integer        :: i, n, status
    type (Results) :: res

    ! Interface para poder utilizar as funções
    interface
         function sol_col(filename, res)
           use utils, only: Results
           character(len=*), intent(in)    :: filename
             type (Results), intent(inout) :: res
         end function sol_col

         function sol_row(filename, res)
           use utils, only: Results
           character(len=*), intent(in)    :: filename
             type (Results), intent(inout) :: res
         end function sol_row
    end interface

    ! Cabeçalho
    print    '(A30, A43)',         "Colunas", "Linhas"
    print    '(A18, $)',           "Nome do arquivo   "
    print    '(A14, 2A10, A8, $)', "Decomposição", "Forward", "Back", "Erro"
    print    '(A17, 2A10, A8)',    "Decomposição", "Forward", "Back", "Erro"

    ! Resolve os sistemas
    n = size(filenames)
    do i = 1, n
        print '(A20, $)', filenames(i)

        ! Resolve com orientação a colunas
        status = sol_col(filenames(i), res)

        if (status == 0) then
            print '(3f10.5, f8.2 $)', res%tdecomp, res%tforw, res%tback, log10(res%erro)
        else
            print *, errmsg
            CYCLE
        end if

        ! Resolve com orientação a linhas
        status = sol_row(filenames(i), res)

        if (status == 0) then
            print '(f15.5, 2f10.5, f8.2)', res%tdecomp, res%tforw, res%tback, log10(res%erro)
        else
            print '(A30)', errmsg
        end if
    end do

  end subroutine solve_systems
end program EP1
