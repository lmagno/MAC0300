module cholesky
implicit none

contains
  function cholcol(n, A)
    integer, intent(in) :: n
    real*8, intent(inout) :: A(:, :)
    integer :: cholcol

    cholcol = n
  end function cholcol

end module cholesky
