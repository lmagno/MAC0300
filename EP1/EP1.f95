program EP1
use    utils, only: pvec, Results
use   sol_lu, only: sol_lu_col, sol_lu_row
use sol_chol, only: sol_chol_col, sol_chol_row
implicit none
    integer :: i, n
    character(len=72), allocatable :: filenames(:)

    n = IARGC()

    ! Usa arquivos padrões caso nenhum seja passado
    ! como argumento
    if (n == 0) then
       n = 9
       allocate(filenames(n))

       ! Arquivos de entrada padrões
       filenames = ['Dados/a1.dat', &
                    'Dados/a2.dat', &
                    'Dados/a3.dat', &
                    'Dados/a4.dat', &
                    'Dados/a5.dat', &
                    'Dados/a6.dat', &
                    'Dados/a7.dat', &
                    'Dados/a8.dat', &
                    'Dados/a9.dat']
    else
       ! Arquivos passados como argumentos
       allocate(filenames(n))
       do i = 1, n
          call get_command_argument(i, filenames(i))
       end do
    end if

    print *, "=============================================== Cholesky ==============================================="
    call solve_systems(filenames, sol_chol_col, sol_chol_row, "A matriz não é definida positiva!")

    print *, ""
    print *, "================================================== LU =================================================="
    call solve_systems(filenames, sol_lu_col, sol_lu_row, "A matriz é singular!")

    deallocate(filenames)

contains
  subroutine solve_systems(filenames, sol_col, sol_row, errmsg)
    character(len=*), intent(inout) :: filenames(:)
    character(len=*) :: errmsg
    integer :: sol_col, sol_row
    integer :: i, n, status
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
    print     '(A30, A45)', "Colunas", "Linhas"
    print       '(A18, $)', "Nome do arquivo   "
    print '(A14, 3A10, $)', "Decomposição", "Forward", "Back", "Erro"
    print    '(A17, 3A10)', "Decomposição", "Forward", "Back", "Erro"

    ! Resolve os sistemas
    n = size(filenames)
    do i = 1, n
        print '(A20, $)', filenames(i)

        ! Resolve com orientação a colunas
        status = sol_col(filenames(i), res)

        if (status == 0) then
            print '(3f10.5, es10.2, $)', res%tdecomp, res%tforw, res%tback, res%erro
        else
            print *, errmsg
            CYCLE
        end if

        ! Resolve com orientação a linhas
        status = sol_row(filenames(i), res)

        if (status == 0) then
            print '(f15.5, 2f10.5, es10.2)', res%tdecomp, res%tforw, res%tback, res%erro
        else
            print *, errmsg
        end if
    end do
    
  end subroutine solve_systems
end program EP1
