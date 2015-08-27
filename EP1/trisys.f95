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
  ! gravando a solução (x ∈ ℝⁿ) sobre o vetor b.
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

  function backcol(n, A, b, trans) result(status)
    
  end function backcol
end module trisys
