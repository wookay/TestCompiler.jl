module test_base_operators

using Test

# ≠ \ne
@test 1 ≠ 2
@test (≠) === (!=)

end # module test_base_operators
