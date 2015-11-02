module CG
    use class_SparseMatrixCSC
    implicit none
    private
    public :: solve_cg
contains
    ! Resolve um sistema linear Ax = b com
    !     A: matriz n×n esparsa e definida positiva
    !     x: vetor de tamanho n denso
    !     b: vetor de tamanho n denso
    ! usando o método dos gradientes conjugados,
    ! guardando o resultado em x.
    subroutine solve_cg(A, b, x, filename)
        type(SparseMatrixCSC), intent(in)  :: A
        real,                  intent(in)  :: b(:)
        real,                  intent(out) :: x(:)
        character(len=*),      intent(in)  :: filename

        integer :: n, i
        real, allocatable :: r(:), p(:), Ap(:)
        real :: eps, rsold, rsnew, alpha

        eps = 1e-30
        open(1, file = filename, status = "replace")

        n = size(b)
        allocate(r(n))
        allocate(p(n))
        allocate(Ap(n))

        ! Inicializa x
        x(:) = 0.0

        ! r = b - A*x
        call A%times(x, r)
        r = b - r

        p = r
        rsold = dot_product(r, r)

        do i = 1, n
            call A%times(p, Ap)
            alpha = rsold/dot_product(p, Ap)
            x = x + alpha*p
            r = r - alpha*Ap

            rsnew = dot_product(r, r)
            write (1, '(i0, " ", e20.6)'), i, sqrt(rsnew)
            if (sqrt(rsnew) < eps) exit

            p = r + (rsnew/rsold)*p
            rsold = rsnew
        end do

        close(1)
        deallocate(r)
        deallocate(p)
        deallocate(Ap)
    end subroutine solve_cg
end module CG
