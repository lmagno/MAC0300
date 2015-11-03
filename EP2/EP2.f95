program EP2
    use exemplos, only: res_t, ex_cg_chol, ex_cg
    implicit none

    integer           :: i, p, n
    type(res_t)       :: res
    real              :: tau, taus(5)
    print '(A5, A6, 7A10)', "n", "τ", "sprand", "to_csc", "CG", "full", "Cholesky", "diff", "posdef"

    taus = [0.001, 0.01, 0.05, 0.1, 0.2]
    do p = 1, 12
        n = 2**p
        do i = 1, 5
            tau = taus(i)

            res = ex_cg_chol(n, tau)
            call res%print
        end do
    end do
end program EP2
