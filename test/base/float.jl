module test_base_float

using Test

# from julia/base/float.jl

@test NaN === NaN64
@test NaN64 isa Float64
@test NaN32 isa Float32
@test NaN16 isa Float16

@test isnan(NaN)

end # module test_base_float
