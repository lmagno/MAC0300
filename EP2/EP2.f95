program EP2
    use class_SparseMatrixCSC
    use class_SparseMatrixCOO
    use RandomSparseMatrix
    implicit none

    type(SparseMatrixCSC) :: A
    type(SparseMatrixCOO) :: tmp
    integer :: hasindex, i, j
    real :: v, w
    ! real :: B(7), C(5)
    !
    ! call tmp%allocate(m = 4, n = 4, nnz = 4)
    ! tmp%colind = [1, 2, 2, 3]
    ! tmp%rowind = [2, 2, 4, 3]
    ! tmp%val    = [5, 8, 6, 3]
    !
    ! call tmp%print
    !
    ! A = tmp%to_csc()
    ! call A%print
    !
    ! call A%deallocate
    ! call tmp%deallocate

    ! call tmp%allocate(m = 5, n = 7, nnz = 9, &
    !                   colind = [1,   2,  2,  3,  3,  4,  5,  6,  7], &
    !                   rowind = [1,   1,  2,  2,  3,  3,  3,  4,  5], &
    !                   val    = real([11, 22, 33, 44, 55, 66, 77, 88, 99]))

    ! tmp%m = 5
    ! tmp%n = 7
    ! tmp%nnz = 0
    ! hasindex = tmp%setindex(1, 1, 11.0)
    ! hasindex = tmp%setindex(5, 7, 99.0)
    tmp = sprand(10000, 0.01)
    call tmp%summary

    do j = 1, tmp%n
        do i = j+1, tmp%m
            hasindex = tmp%getindex(i, j, v)
            hasindex = tmp%getindex(j, i, w)

            if (abs(v - w) > 1e-16) then
                print '("Não é simétrica! ", e10.4)', abs(v-w)
            end if
        end do
    end do
    A = tmp%to_csc()
    call A%summary
    call tmp%deallocate
    ! print *, tmp%val
    ! print *, tmp%getindex(5, 7, v)
    ! A = tmp%to_csc()
    ! call A%print
    ! call tmp%deallocate
    !
    ! B = [1, 1, 1, 1, 1, 1, 1]
    ! call A%times(B, C)
    ! print *, C
    ! call A%deallocate
end program EP2
