program EP1
use utils, only: pvec, results
use solchol,    only: solcholcol, solcholrow
use sollu, only: sollucol, sollurow
implicit none
    integer :: i, n, status
    type (results) :: res
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
    print  '(A30, A45)', "Colunas", "Linhas"
    print    '(A18, $)', "Nome do arquivo   "
    print   '(A14, 3A10, $)', "Decomposição", "Forward", "Back", "Erro"
    print      '(A17, 3A10)', "Decomposição", "Forward", "Back", "Erro"


    ! Resolve os sistemas
    do i = 1, n
        print '(A20, $)', filenames(i)

        ! Resolve com orientação a colunas
        status = solcholcol(filenames(i), res)

        if (status == 0) then
            print '(3f10.5, es10.2, $)', res%tdecomp, res%tforw, res%tback, res%erro
        else
            print *, "A matriz não é definida positiva!"
            CYCLE
        end if

        ! Resolve com orientação a linhas
        status = solcholrow(filenames(i), res)

        if (status == 0) then
            print '(f15.5, 2f10.5, es10.2)', res%tdecomp, res%tforw, res%tback, res%erro
        else
            print *, "A matriz não é definida positiva!"
        end if
    end do

    print *, ""
    print *, "================================================== LU =================================================="
    print  '(A30, A45)', "Colunas", "Linhas"
    print    '(A18, $)', "Nome do arquivo   "
    print   '(A14, 3A10, $)', "Decomposição", "Forward", "Back", "Erro"
    print      '(A17, 3A10)', "Decomposição", "Forward", "Back", "Erro"


    ! Resolve os sistemas
    do i = 1, n
        print '(A20, $)', filenames(i)

        ! Resolve com orientação a colunas
        status = sollucol(filenames(i), res)

        if (status == 0) then
            print '(3f10.5, es10.2, $)', res%tdecomp, res%tforw, res%tback, res%erro
        else
            print *, "A matriz é singular!"
            CYCLE
        end if

        ! Resolve com orientação a linhas
        status = sollurow(filenames(i), res)

        if (status == 0) then
            print '(f15.5, 2f10.5, es10.2)', res%tdecomp, res%tforw, res%tback, res%erro
        else
            print *, "A matriz é singular!"
        end if
    end do

    deallocate(filenames)
end program EP1
