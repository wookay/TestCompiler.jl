module test_corecompiler_tfuncs

# see also base/runtime_internals.jl

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
specs = mg.specializations
if specs isa Core.SimpleVector
    @test VERSION >= v"1.14.0-DEV.2337" # julia commit 76a2a8fd25  gf: redesign specialization strategy
    mgi = first(specs)
    @test mgi isa Core.MethodInstance
    @test mgi.specTypes === Tuple{typeof(g), Int}
else
    @test VERSION < v"1.14.0-DEV.2337"
    mgi = specs
    @test mgi isa Core.MethodInstance
    @test mgi.specTypes === Tuple{typeof(g), Any}
end


CC.egal_tfunc

# from julia/Compiler/test/inference.jl
function egal_tfunc(a, b)
    𝕃 = CC.fallback_lattice
    return CC.egal_tfunc(𝕃, a, b)
end

@test egal_tfunc(Const(3), Const(1+2)) === Const(true)
@test egal_tfunc(Const(1), Const(2)) === Const(false)
@test egal_tfunc(String, Int) === Const(false)
@test egal_tfunc(Nothing, Nothing) === Bool
@test egal_tfunc(Int64, Int64) === Bool

struct S
end
@test egal_tfunc(S, S) == Bool


# from julia/Compiler/src/stmtinfo.jl
# struct CallMeta

# from julia/Compiler/src/inferencestate.jl
# struct Future{T}

# from julia/Compiler/src/tfuncs.jl
# function return_type_tfunc(interp::AbstractInterpreter, argtypes::Vector{Any}, si::StmtInfo, sv::AbsIntState)

using .CC: CallMeta, Effects, EFFECTS_THROWS, NoCallInfo, CallInfo
rt = Type
exct = Any
effects = Effects(EFFECTS_THROWS; nortcall=false)
info = NoCallInfo() # NoCallInfo <: CallInfo
refinements = nothing # ::Union{Nothing,SlotRefinement,Vector{Any}}

if VERSION >= v"1.12"
UNKNOWN = CallMeta(rt::Any, exct::Any, effects::Effects, info::CallInfo, refinements)
@test UNKNOWN isa CallMeta

using .CC: Future
future = Future(UNKNOWN)
@test future isa Future{CallMeta}
end # if

if VERSION >= v"1.14.0-DEV.2597" # julia commit e7fe47b022
Core.TypeEgal

CC.isTypeEgal
CC.isTypeEq
CC.isType
CC.isconstType
end

end # module test_corecompiler_tfuncs
