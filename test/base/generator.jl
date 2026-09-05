module test_base_generator

using Test

v = [1.0, 2.0, 3.0]
g = (count(iszero, v .* i) for i in 1:2)
@test g isa Base.Generator
@test collect(g) == [0, 0]
@test g.f([0, 0, 0]) == 3
@test g.f(v) == 0
@test g.iter == 1:2

@test Base.infer_return_type(count, (typeof(iszero), Vector{Float64})) === Int
@test Base.infer_return_type(g.f, (Vector{Float64},)) === Any


# from test/reduce.jl
# @testset "type-stability for nested reductions" begin
nested_count(v::Vector{Float64}) = maximum(count(!iszero, v .* i) for i in 1:3)
@test nested_count([1.0, 2.0]) == 2
T = Base.infer_return_type(nested_count, (Vector{Float64},))
if VERSION >= v"1.14.0-DEV.3115" # julia commit 10e7005f38
    @test T === Int
else
    @test T === Any
end

end # module test_base_generator
