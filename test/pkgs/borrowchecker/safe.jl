using Jive
@If VERSION >= v"1.12" module test_pkgs_borrowchecker_safe

using Test
using BorrowChecker: BorrowChecker
using .BorrowChecker.Auto: BorrowCheckError

BorrowChecker.@safe function f()
    x = [1, 2, 3]
    y = x
    push!(x, 4)
    return y
end

@test_throws BorrowCheckError f()

end # module test_pkgs_borrowchecker_safe
