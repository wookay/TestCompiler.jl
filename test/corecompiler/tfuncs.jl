module test_corecompiler_tfuncs

using Test
using Core: Compiler as CC
using .CC: @nospecs

f(x) = nothing
f(1)
f("")
f(3.14)

mf = only(methods(f))
@test mf.specializations isa Core.SimpleVector

@nospecs g(x) = nothing
g(1)
g("")
g(3.14)

mg = only(methods(g))
mgi = mg.specializations
@test mgi isa Core.MethodInstance
@test mgi.specTypes === Tuple{typeof(g), Any}

Base.issingletontype
@test Base.issingletontype(Nothing)

CC.egal_tfunc

# from julia/Compiler/test/inference.jl
function egal_tfunc(a, b)
    𝕃 = CC.fallback_lattice
    return CC.egal_tfunc(𝕃, a, b)
end

@test egal_tfunc(CC.Const(3), CC.Const(1+2)) == CC.Const(true)
@test egal_tfunc(CC.Const(1), CC.Const(2)) == CC.Const(false)
@test egal_tfunc(Int, Int) == Bool
@test egal_tfunc(String, Int) == CC.Const(false)

end # module test_corecompiler_tfuncs
