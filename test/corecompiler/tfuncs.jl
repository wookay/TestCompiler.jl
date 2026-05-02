module test_corecompiler_tfuncs

using Test
using Core: Compiler as CC
using .CC: @nospecs, Const

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
# from julia/base/runtime_internals.jl
#=
"""
    Base.issingletontype(T)

Determine whether type `T` has exactly one possible instance; for example, a
struct type with no fields except other singleton values.
If `T` is not a concrete type, then return `false`.
"""
issingletontype(@nospecialize(t)) = (@_total_meta; isa(t, DataType) && isdefined(t, :instance) && datatype_layoutsize(t) == 0 && datatype_pointerfree(t))
=#
@test Base.issingletontype(Nothing)
@test !(Base.issingletontype(Int64))

struct S
end
@test Base.isconcretetype(S)
@test Base.issingletontype(S)


CC.egal_tfunc

# from julia/Compiler/test/inference.jl
function egal_tfunc(a, b)
    𝕃 = CC.fallback_lattice
    return CC.egal_tfunc(𝕃, a, b)
end

@test egal_tfunc(Const(3), Const(1+2)) == Const(true)
@test egal_tfunc(Const(1), Const(2)) == Const(false)
@test egal_tfunc(String, Int) == Const(false)
@test egal_tfunc(Nothing, Nothing) == Bool
@test egal_tfunc(Int64, Int64) == Bool
@test egal_tfunc(S, S) == Bool

end # module test_corecompiler_tfuncs
