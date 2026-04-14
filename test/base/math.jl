module test_base_math

using Test

@test isinf(/(Inf, 0))
@test isnan(/(Inf, Inf))
@test /(0, Inf) == 0.0

end # module test_base_math
