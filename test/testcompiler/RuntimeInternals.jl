module test_testcompiler_RuntimeInternals

using Test
using TestCompiler.RuntimeInternals

UT = Union{Int, String}
@test RuntimeInternals.uniontypes(UT) == Type[Int, String]
@test only(Base.return_types(RuntimeInternals.uniontypes, Tuple{Union})) === Vector{Type}

@test Base.uniontypes(UT) == Any[Int, String]
@test only(Base.return_types(Base.uniontypes, Tuple{Union})) === Vector{Any}

# from julia/base/reducedim.jl
using Base: BitInteger, IEEEFloat
for uniontypes in (RuntimeInternals.uniontypes, Base.uniontypes)
let
    BitIntFloat = Union{BitInteger, IEEEFloat}
    T = Union{
        Type[AbstractArray{t} for t in uniontypes(BitIntFloat)]...,
        Type[AbstractArray{Complex{t}} for t in uniontypes(BitIntFloat)]...}
    @test Base.unionlen(T) == 26
end # let
end # for

end # module test_testcompiler_RuntimeInternals
