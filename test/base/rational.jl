module test_base_rational

using Test

@test rationalize(pi) == 2646693125139304345//842468587426513207
@test isapprox(pi, rationalize(pi), atol=0.000000000000001)

end # module test_base_rational
