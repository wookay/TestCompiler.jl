module test_corecompiler_object_model_functions

using Test

@test getfield(1//2, :den) == 2

d = Dict(:num => 1)
@test get(d, :den, nothing) === nothing
d[:den] = 2
@test getindex(d, :den) == 2

struct MathematicalBoldCapitalR
end
function Base.getproperty(::MathematicalBoldCapitalR, sym::Symbol)
    string("𝐑.", sym)
end
𝐑 = MathematicalBoldCapitalR()
@test 𝐑.den == "𝐑.den"

end # module test_corecompiler_object_model_functions
