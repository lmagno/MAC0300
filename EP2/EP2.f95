program EP2
    use exemplos, only: res_t, ex_cg_chol, ex_cg
    implicit none

    integer           :: i, n, max
    logical           :: cg_only
    type(res_t)       :: res
    integer           :: argc
    character(len=32) :: argv
    real              :: tau

    argc = IARGC()
    if (argc > 0) then
        call get_command_argument(1, argv)
        read (argv, *) max
    else
        max = 12
    end if
    cg_only = .false.
    print '(A5, 7A10)', "n", "sprand", "to_csc", "CG", "full", "Cholesky", "diff", "posdef"

    tau = 0.1
    do i = 1, max
        n = 2**i

        if (cg_only) then
            res = ex_cg(n, tau)
        else
            res = ex_cg_chol(n, tau)
        end if

        call res%print
        if (res%total() > 100) cg_only = .true.
    end do
end program EP2
