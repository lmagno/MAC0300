module lu
use utils, only: swap, Results
use trisys,   only: forwcol, forwrow, backcol, backrow
implicit none
contains
  function lucol(n, A, p) result(status)
    integer, intent(in)    :: n
       real, intent(inout) :: A(:, :)
    integer, intent(out)   :: p(:)
    integer :: i, j, k
    integer :: imax, status

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
            call swap(A(k, j), A(imax, j))
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
  
  function sscol(n, A, p, b, res) result(status)
    integer, intent(in)    :: n, p(:)
    real, intent(in)    :: A(:, :)
    real, intent(inout) :: b(:)
    type (Results), intent(inout) :: res
    integer :: i, status
    real :: start, finish
  
    ! Calcula Pb
    do i = 1, n
       call swap(b(i), b(p(i)))
    end do

    ! Agora temos o sistema
    !    LUx = Pb

    ! Primeiro resolvemos
    !    Ly = Pb

    call cpu_time(start)
    status = forwcol(n, A, b, unit = .true.)
    call cpu_time(finish)
    res%tforw = finish - start

    if (status == -1) then
       return
    end if

    ! Agora resolvemos
    !    Ux = y
    call cpu_time(start)
    status = backcol(n, A, b, trans = .false.)
    call cpu_time(finish)
    res%tback = finish - start

    if (status == -1) then
       return
    end if

  end function sscol

end module lu
