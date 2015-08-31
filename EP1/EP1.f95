program EP1
use matriz, only: pvec
use sol,    only: results, solcol, solrow 
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

    print  '(A30, A45)', "Colunas", "Linhas"
    print    '(A20, $)', "Nome do arquivo     "
    print   '(4A10, $)', "Cholesky", "Forward", "Backward", "Erro"
    print '(A15, 3A10)', "Cholesky", "Forward", "Backward", "Erro"


    ! Resolve os sistemas
    do i = 1, n
        print '(A20, $)', filenames(i)
        
        ! Resolve com orientação a colunas
        status = solcol(filenames(i), res)

        if (status == 0) then
            print '(3f10.5, es10.2, $)', res%tchol, res%tforw, res%tback, res%erro
        else
            print *, "A matriz não é definida positiva!"
            CYCLE
        end if

        ! Resolve com orientação a linhas
        status = solrow(filenames(i), res)

        if (status == 0) then
            print '(f15.5, 2f10.5, es10.2)', res%tchol, res%tforw, res%tback, res%erro
        else
            print *, "A matriz não é definida positiva!"
        end if
    end do


    deallocate(filenames)
end program EP1
