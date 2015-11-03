program EP2
    use exemplos, only: res_t, ex_cg_chol, ex_cg
    implicit none

    integer           :: i, p, n
    type(res_t)       :: res
    real              :: tau, taus(5)
    open(2, file = "output", status = "replace")
    write(2, '(A5, A7, 7A10)'), "n", "τ", "sprand", "to_csc", "CG", "full", "Cholesky", "diff", "posdef"

    taus = [0.001, 0.01, 0.05, 0.1, 0.2]
    do p = 1,12
        n = 2**p
        do i = 1, 5
            tau = taus(i)

            res = ex_cg_chol(n, tau)
            write (2, '(A)'), res%string()
            flush(2)
        end do
    end do

    close(1)
end program EP2
