program EP2
    use class_SparseMatrixCSC
    use class_SparseMatrixCOO
    implicit none

    type(SparseMatrixCSC) :: A
    type(SparseMatrixCOO) :: tmp
    real :: v
    real :: B(7), C(5)
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

    call tmp%allocate(m = 5, n = 7, nnz = 9)
    tmp%colind = [1,   2,  2,  3,  3,  4,  5,  6,  7]
    tmp%rowind = [1,   1,  2,  2,  3,  3,  3,  4,  5]
    tmp%val    = [11, 22, 33, 44, 55, 66, 77, 88, 99]

    call tmp%reallocate(10)
    call tmp%print
    print *, tmp%val
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
