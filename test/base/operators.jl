module test_base_operators

using Test

# ≠ \ne
@test 1 ≠ 2
@test (≠) === (!=)

end # module test_base_operators


using Jive
@If VERSION >= v"1.14.0-DEV.2629" module test_base_operators_wrapping_arithmetic_op
# julia commit b6e5cb5a65

using Test
op = -%
@test op(3, 2) == 1

end # module test_base_operators_wrapping_arithmetic_op
