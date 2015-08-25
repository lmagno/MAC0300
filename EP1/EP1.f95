program EP1
use input
implicit none
    integer :: n, i, j, k
    real*8, dimension(:)   , allocatable :: b
    real*8, dimension(:, :), allocatable :: A


    call leSistema(n, A, b)
    print *, shape(A)
    print *, shape(b)
    ! do i = 1, n
    !     print *, A(i, :)
    ! end do


    ! Desaloca a matriz A e o vetor b
    deallocate(b)
    deallocate(A)
end program EP1


! function cholcol(n, A)
! implicit none
!     integer, intent(in) :: n
!     real*8, dimension(:, :), intent(inout) :: A
!     integer :: cholcol
!     n = 2
!
!     cholcol = n
! end function
