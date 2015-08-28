program EP1
use matriz,   only: pvec
use entrada,  only: le_sistema
use cholesky, only: cholcol, cholrow
use trisys,   only: forwcol, forwrow, backcol, backrow
implicit none
    integer :: n, i, s
    real, allocatable, dimension(:, :) :: A
    real, allocatable, dimension(:)    :: b, x
    character(len=72) :: filename
    real :: start, finish

    ! Lê qual arquivo de entrada deve ser utilizado
    ! através de um argumento de linha de comando
    ! e carrega o sistema descrito nele
    call get_command_argument(1, filename)
    call le_sistema(n, A, b, filename)    

    
    ! Calcula a solução esperada do sistema 
    allocate(x(n))
    x = [(1 + mod(i-1, n/100), i = 1, n)]

    call cpu_time(start)
    s = cholcol(n, A)
    call cpu_time(finish)
    print '("cholcol: ", es10.3)', finish-start
    ! Agora temos o sistema
    ! GGᵀx = b

    ! Gy = b
    call cpu_time(start)
    s = forwcol(n, A, b)
    call cpu_time(finish)
    print '("forwcol: ", es10.3)', finish-start

    ! Gᵀx = y
    call cpu_time(start)
    s = backcol(n, A, b, .true.)
    call cpu_time(finish)
    print '("backcol: ", es10.3)', finish-start
    x = x-b
    
    print '("O erro foi: ", es10.2)', sqrt(dot_product(x, x))
  
    ! Desaloca a matriz A e o vetor b
    deallocate(x)
    deallocate(b)
    deallocate(A)
end program EP1
