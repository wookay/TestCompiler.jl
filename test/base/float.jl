module test_base_float

# see also test/base/meta.jl

# from julia/base/float.jl

using Test

@test NaN === NaN64
@test NaN64 isa Float64
@test NaN32 isa Float32
@test NaN16 isa Float16

@test isnan(NaN)

@test 1e0 ===  1.0
@test 1e1 === 10.0

end # module test_base_float
