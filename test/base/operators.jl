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

@test splat(+)((1, 2, 3)) == +(1, 2, 3) == 6

if VERSION >= v"1.14.0-DEV.3057" # julia commit 8c9c94f563
unsplat
@test unsplat(sum) === sum ∘ tuple
@test unsplat(sum)(1, 2, 3) == sum((1, 2, 3)) == 6
@test (splat ∘ unsplat)(sum) === (unsplat ∘ splat)(sum) === sum
end

end # module test_base_operators_wrapping_arithmetic_op
