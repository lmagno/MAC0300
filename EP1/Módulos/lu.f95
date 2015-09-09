module lu
implicit none
contains
  function lucol(n, A, p) result(status)
    integer, intent(in)    :: n
       real, intent(inout) :: A(:, :), p(:)
    integer :: i, j, k, m
    integer :: imax, status
       real :: tmp

    status = -1
    do k = 1, n
       
       ! Acha o máximo elemento absoluto da coluna k
       ! e guarda a linha em que ele aparece
       imax = k
       do i = k+1, n
          if (abs(A(i, k)) > abs(A(imax, k))) then
             imax = i
          end if
       end do

       ! Verifica se a matriz é singular
       if (A(imax, k) == 0.0) then
          return
       end if

       p(k) = imax
       ! Troca as linhas de forma a deixar o maior elemento
       ! da coluna k na posição de pivô 
       if (imax /= k) then
          do j = 1, n
             tmp = A(k, j)
             A(k, j) = A(imax, j)
             A(imax, j) = tmp
          end do
       end if

       do i = k+1, n
          A(i, k) = A(i, k)/A(k, k)
       end do

       do j = k+1, n
          do i = k+1, n
             A(i, j) = A(i, j) - A(k, j)*A(i, k)
          end do
       end do
    end do

    status = 0
  end function lucol
end module lu
