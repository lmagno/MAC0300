module sol
use entrada,  only: le_sistema
use cholesky, only: cholcol, cholrow
use trisys,   only: forwcol, forwrow, backcol, backrow
implicit none

  type results
     sequence
     real :: erro
     real :: tchol, tforw, tback
  end type results

contains
  function solcol(filename, res) result(status)
    character(len=*), intent(in) :: filename
    type (results), intent(out) :: res
    integer :: n, i, status
    real :: start, finish
    real, allocatable, dimension(:, :) :: A
    real, allocatable, dimension(:)    :: x, b
    status = 0

    ! Carrega o sistema
    call le_sistema(n, A, b, filename)

    ! Calcula o fator de Cholesky G da matriz A
    ! tal que A = GGᵀ
    call cpu_time(start)
    status = cholcol(n, A)
    call cpu_time(finish)
    res%tchol = finish - start

    ! Retorna a função caso a matriz não seja
    ! positiva definida
    if (status == -1) then
       return
    end if

    ! Agora temos o sistema
    !     G(Gᵀx) = b
    
    ! Gy = b
    call cpu_time(start)
    status = forwcol(n, A, b)
    call cpu_time(finish)
    res%tforw = finish - start
    
    ! Retorna a função caso a matriz seja
    ! singular
    if (status == -1) then
       return
    end if    

    ! Gᵀx = y
    call cpu_time(start)
    status = backcol(n, A, b, .true.)
    call cpu_time(finish)
    res%tback = finish - start
    
    ! Retorna a função caso a matriz seja
    ! singular
    if (status == -1) then
       return
    end if    

    ! Aloca e calcula o vetor solução esperado
    allocate(x(n))
    x = [(1 + mod(i-1, n/100), i = 1, n)]

    ! Calcula a norma do vetor diferença
    ! entre a solução esperada e a obtida,
    ! como forma de estimativa do erro
    res%erro = norm2(x - b)/n


    ! Libera a memória
    deallocate(x)
    deallocate(b)
    deallocate(A)
  end function solcol

  function solrow(filename, res) result(status)
    character(len=*), intent(in) :: filename
    type (results), intent(out) :: res
    integer :: n, i, status
    real :: start, finish
    real, allocatable, dimension(:, :) :: A
    real, allocatable, dimension(:)    :: x, b
    status = 0

    ! Carrega o sistema
    call le_sistema(n, A, b, filename)

    ! Calcula o fator de Cholesky G da matriz A
    ! tal que A = GGᵀ
    call cpu_time(start)
    status = cholrow(n, A)
    call cpu_time(finish)
    res%tchol = finish - start

    ! Retorna a função caso a matriz não seja
    ! positiva definida
    if (status == -1) then
       return
    end if

    ! Agora temos o sistema
    !     G(Gᵀx) = b
    
    ! Gy = b
    call cpu_time(start)
    status = forwrow(n, A, b)
    call cpu_time(finish)
    res%tforw = finish - start
    
    ! Retorna a função caso a matriz seja
    ! singular
    if (status == -1) then
       return
    end if    

    ! Gᵀx = y
    call cpu_time(start)
    status = backrow(n, A, b, .true.)
    call cpu_time(finish)
    res%tback = finish - start
    
    ! Retorna a função caso a matriz seja
    ! singular
    if (status == -1) then
       return
    end if    

    ! Aloca e calcula o vetor solução esperado
    allocate(x(n))
    x = [(1 + mod(i-1, n/100), i = 1, n)]

    ! Calcula a norma do vetor diferença
    ! entre a solução esperada e a obtida,
    ! como forma de estimativa do erro
    res%erro = norm2(x - b)/n


    ! Libera a memória
    deallocate(x)
    deallocate(b)
    deallocate(A)
  end function solrow

end module sol
