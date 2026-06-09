module test_base_promotion

using Test

# from julia/base/promotion.jl

@test promote(1, false, false) == (1, 0, 0)
@test   0 ==  false
@test !(0 === false)

@test promote_type(Int, Bool, Bool) === Int

end # module test_base_promotion
