! Módulo para juntar funções que resolvem sistemas
! lineares cuja matriz de coeficientes é triangular
! inferior ou superior
module trisys
implicit none
contains
  ! Resolve um sistema linear
  !    Ax = b
  ! com
  !    A ∈ ℝⁿˣⁿ, triangular inferior
  !    b ∈ ℝⁿ
  ! com orientação a colunas, gravando 
  ! a solução (x ∈ ℝⁿ) sobre o vetor b.
  ! Retorna
  !     0: caso tenha resolvido o sistema com sucesso
  !    -1: caso a matriz A seja singular e sistema
  !        não possa ser resolvido
  ! 
  function forwcol(n, A, b) result(status)
    integer, intent(in) :: n
    real, intent(inout) :: A(:, :), b(:)
    integer :: i, j, status
    real :: ajj, bj

    status = -1

    do j = 1, n
       ajj = A(j, j)
       if (ajj == 0) then
          return
       end if

       bj = b(j)/ajj
       b(j) = bj

       do i = j+1, n
          b(i) = b(i) - bj*A(i, j)
       end do
    end do

    status = 0
  end function forwcol

  ! Resolve um sistema linear
  !    Ax = b
  ! com
  !    A ∈ ℝⁿˣⁿ, triangular inferior
  !    b ∈ ℝⁿ
  ! com orientação a linhas, gravando 
  ! a solução (x ∈ ℝⁿ) sobre o vetor b.
  ! Retorna
  !     0: caso tenha resolvido o sistema com sucesso
  !    -1: caso a matriz A seja singular e sistema
  !        não possa ser resolvido
  ! 
  function forwrow(n, A, b) result(status)
    integer, intent(in) :: n
    real, intent(inout) :: A(:, :), b(:)
    integer :: i, j, status
    real :: aii

    status = -1

    do i = 1, n
       aii = A(i, i)
       if (aii == 0) then
          return
       end if

       do j = 1, i-1
          b(i) = b(i) - b(j)*A(i, j)
       end do

       b(i) = b(i)/aii
    end do

    status = 0
  end function forwrow


  ! Resolve um sistema linear
  !    Ax = b
  ! com
  !    A ∈ ℝⁿˣⁿ, triangular superior
  !    b ∈ ℝⁿ
  ! com orientação a colunas, gravando 
  ! a solução (x ∈ ℝⁿ) sobre o vetor b.
  !   Além disso, pode receber no lugar de A,
  ! sua transposta, fato indicado pela variável
  ! trans.
  ! Retorna
  !     0: caso tenha resolvido o sistema com sucesso
  !    -1: caso a matriz A seja singular e sistema
  !        não possa ser resolvido
  function backcol(n, A, b, trans) result(status)
    integer, intent(in) :: n
    real, intent(inout) :: A(:, :), b(:)
    logical, intent(in) :: trans
    integer :: i, j, status
    real :: ajj, bj

    status = -1
    if (trans) then
       do j = n, 1, -1
          ajj = A(j, j)
          if (ajj == 0) then
             return
          end if
          
          do i = j+1, n
             b(j) = b(j) - b(i)*A(i, j)
          end do

          b(j) = b(j)/ajj
       end do
       status = 0
       return
    else
       do j = n, 1, -1
          ajj = A(j, j)
          if (ajj == 0) then
             return
          end if

          b(j) = b(j)/ajj
          bj = b(j)

          do i = 1, j-1
             b(i) = b(i) - bj*A(i, j)
          end do
       end do

       status = 0
       return
    end if
  end function backcol

  ! Resolve um sistema linear
  !    Ax = b
  ! com
  !    A ∈ ℝⁿˣⁿ, triangular superior
  !    b ∈ ℝⁿ
  ! com orientação a linhas, gravando 
  ! a solução (x ∈ ℝⁿ) sobre o vetor b.
  !   Além disso, pode receber no lugar de A,
  ! sua transposta, fato indicado pela variável
  ! trans.
  ! Retorna
  !     0: caso tenha resolvido o sistema com sucesso
  !    -1: caso a matriz A seja singular e sistema
  !        não possa ser resolvido
  function backrow(n, A, b, trans) result(status)
    integer, intent(in) :: n
    real, intent(inout) :: A(:, :), b(:)
    logical, intent(in) :: trans
    integer :: i, j, status
    real :: aii, bi

    status = -1
    if (trans) then
       do i = n, 1, -1
          aii = A(i, i)
          if (aii == 0) then
             return
          end if

          b(i) = b(i)/aii
          bi = b(i)

          do j = 1, i-1
             b(j) = b(j) - bi*A(i, j)
          end do
       end do

       status = 0
       return
    else
       do i = n, 1, -1
          aii = A(i, i)
          if (aii == 0) then
             return
          end if
          
          do j = i+1, n
             b(i) = b(i) - b(j)*A(i, j)
          end do

          b(i) = b(i)/aii
       end do
       status = 0
       return
    end if
  end function backrow
end module trisys
