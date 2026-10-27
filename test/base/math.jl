module test_base_math

using Test

@test isinf(/(Inf, 0))
@test isnan(/(Inf, Inf))
@test /(0, Inf) == 0.0

@test √(2 ^ 2) == 2 ^ 1 ==  2
@test √(2 ^ 4) == 2 ^ 2 ==  4
@test √(2 ^ 6) == 2 ^ 3 ==  8
@test √(2 ^ 8) == 2 ^ 4 == 16

@test √(3 ^ 2) == 3 ^ 1 ==  3
@test √(3 ^ 4) == 3 ^ 2 ==  9
@test √(3 ^ 6) == 3 ^ 3 == 27
@test √(3 ^ 8) == 3 ^ 4 == 81

end # module test_base_math
