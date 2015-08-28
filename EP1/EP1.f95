program EP1
use matriz, only: pvec
use sol,    only: results, solcol 
implicit none
    integer :: i, status, argc
    type (results) :: res
    character(len=72) :: filename
    character(len=72) :: filenames(9)

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
 
    
    print'(A20, 4A10)', "Nome do arquivo     ", "Cholesky", "Forward", "Backward", "Erro"
    

    argc = IARGC()
    if (argc == 0) then
        ! Resolve os sistemas padrões
        do i = 1, 9
            print '(A20, $)', filenames(i)
            status = solcol(filenames(i), res)

            if (status == 0) then
                print '(3f10.5, es10.2, $)', res%tchol, res%tforw, res%tback, res%erro
            else
                print *, "A matriz não é definida positiva!"
                CYCLE
            end if

            print *, "vuash!"
        end do

    else
        ! Resolve os sistemas fornecidos pelo usuário
        do i = 1, argc
            call get_command_argument(i, filename)
            status = solcol(filename, res)

            if (status == 0) then
               print '(A20, 3f10.5, es10.2)', filename, res%tchol, res%tforw, res%tback, res%erro
            else
               print '(A20, A)', filename, "A matriz não é definida positiva!"
            end if
        end do
    end if
end program EP1
