program EP2
    use class_SparseMatrixCSC
    use class_SparseMatrixCOO
    use RandomSparseMatrix
    use CG
    implicit none

    type(SparseMatrixCSC) :: A
    type(SparseMatrixCOO) :: tmp
    integer :: hasindex, i, j
    real :: v, w
    real :: b(2), x(2)

    call tmp%init(2, 2)
    hasindex = tmp%setindex(1, 1, 4.0)
    hasindex = tmp%setindex(1, 2, 1.0)
    hasindex = tmp%setindex(2, 1, 1.0)
    hasindex = tmp%setindex(2, 2, 3.0)

    A = tmp%to_csc()
    call A%print

    b = [1, 2]
    call solve(A, b, x)
    print *, x
    call tmp%deallocate
end program EP2
