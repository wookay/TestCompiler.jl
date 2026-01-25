using Jive
@If VERSION >= v"1.12" module test_corecompiler_abstract_interpretation

using Test
using Core: Compiler as CC
using .CC: CallInfo, CallMeta, RTEffects, Future, Effects, EFFECTS_THROWS, NoCallInfo,
           ArgInfo,
           isready

f = Future{CallMeta}()
@test !isready(f)

# from julia/Compiler/src/tfuncs.jl
#      function return_type_tfunc(interp::AbstractInterpreter, argtypes::Vector{Any}, si::StmtInfo, sv::AbsIntState)
UNKNOWN = CallMeta(Type, Any, Effects(EFFECTS_THROWS; nortcall=false), NoCallInfo())
fu = Future(UNKNOWN)
@test isready(fu)
@test getindex(fu) == UNKNOWN

(; fargs, argtypes) = ArgInfo(nothing, [])
@test fargs === nothing
@test argtypes == []


using Core: CodeInstance, CodeInfo, ReturnNode
using Base.Experimental: @MethodTable, @overlay

# from julia/Compiler/test/AbstractInterpreter.jl
@MethodTable OVERLAY_PLUS_MT
function overlay_plus end
overlay_plus(x, y) = :default
@overlay OVERLAY_PLUS_MT overlay_plus(x::Int, y::Int) = :overlay

# from julia/Compiler/test/irutils.jl
code_typed1(args...; kwargs...) = first(only(code_typed(args...; kwargs...)))::CodeInfo

using FemtoCompiler: FemtoInterpreter
OverlayPlusInterp = FemtoInterpreter

CC.method_table(interp::OverlayPlusInterp) = CC.OverlayMethodTable(CC.get_inference_world(interp), OVERLAY_PLUS_MT)

f = overlay_plus

interp = OverlayPlusInterp()
let src = code_typed1(f, (Int, Int); interp)
    line = src.code[end]
    @test line == ReturnNode(:(:overlay))
end

let src = code_typed1(f, (Int, Int))
    line = src.code[end]
    @test line == ReturnNode(:(:default))
end

# from julia/Compiler/src/types.jl
# Quickly and easily satisfy the AbstractInterpreter API contract
@test CC.InferenceParams(interp) == CC.InferenceParams(3, 4, 8, 32, 3, true, false, false, false, false)
@test CC.OptimizationParams(interp) == CC.OptimizationParams(true, 100, 1000, 250, 32, true, false, false)
@test CC.get_inference_world(interp) == Base.get_world_counter()
@test CC.get_inference_cache(interp) == CC.InferenceResult[]
# @test CC.cache_owner(interp) !== nothing


# from julia/Compiler/src/types.jl
#=
struct ArgInfo
    fargs::Union{Nothing,Vector{Any}}
    argtypes::Vector{Any}
end

abstract type CallInfo end
=#


# from julia/Compiler/src/stmtinfo.jl
#=
"""
    call::CallMeta

A simple struct that captures both the return type (`call.rt`)
and any additional information (`call.info`) for a given generic call.
"""
struct CallMeta
    rt::Any
    exct::Any
    effects::Effects
    info::CallInfo
    refinements # ::Union{Nothing,SlotRefinement,Vector{Any}}
    function CallMeta(rt::Any, exct::Any, effects::Effects, info::CallInfo,
                      refinements=nothing)
        @nospecialize rt exct info
        return new(rt, exct, effects, info, refinements)
    end
end

struct NoCallInfo <: CallInfo end

"""
Captures the essential arguments and result of a `:jl_matching_methods` lookup
for the given call (`info.results`). This info may then be used by the
optimizer, without having to re-consult the method table.
This info is illegal on any statement that is not a call to a generic function.
"""
struct MethodMatchInfo <: CallInfo

"""
If inference decides to partition the method search space by splitting unions,
it will issue a method lookup query for each such partition. This info indicates
that such partitioning happened and wraps the corresponding `MethodMatchInfo` for
each partition (`info.matches::Vector{MethodMatchInfo}`).
This info is illegal on any statement that is not a call to a generic function.
"""
struct UnionSplitInfo <: CallInfo

"""
This struct represents a method result constant was proven to be effect-free.
"""
struct MethodResultPure <: CallInfo

"""
Captures all the information for abstract iteration analysis of a single value.
Each (abstract) call to `iterate`, corresponds to one entry in `ainfo.each::Vector{CallMeta}`.
"""
struct AbstractIterationInfo

"""
This info applies to any call of `_apply_iterate(...)` and captures both the
info of the actual call being applied and the info for any implicit call
to the `iterate` function. Note that it is possible for the call itself
to be yet another `_apply_iterate`, in which case the `info.call` field will
be another `ApplyCallInfo`. This info is illegal on any statement that is
not an `_apply_iterate` call.
"""
struct ApplyCallInfo <: CallInfo

"""
Like `UnionSplitInfo`, but for `ApplyCallInfo` rather than `MethodMatchInfo`.
This info is illegal on any statement that is not an `_apply_iterate` call.
"""
struct UnionSplitApplyCallInfo <: CallInfo

"""
Represents a resolved call to `Core.invoke` targeting a `Core.CodeInstance`
"""
struct InvokeCICallInfo <: CallInfo

"""
Represents a resolved call to `Core.invoke`, carrying the `info.match::MethodMatch` of
the method that has been processed.
Optionally keeps `info.result::InferenceResult` that keeps constant information.
"""
struct InvokeCallInfo <: CallInfo

"""
Represents a resolved call of opaque closure, carrying the `info.match::MethodMatch` of
the method that has been processed.
Optionally keeps `info.result::InferenceResult` that keeps constant information.
"""
struct OpaqueClosureCallInfo <: CallInfo

"""
This info may be constructed upon opaque closure construction, with `info.unspec::CallMeta`
carrying out inference result of an unreal, partially specialized call (i.e. specialized on
the closure environment, but not on the argument types of the opaque closure) in order to
allow the optimizer to rewrite the return type parameter of the `OpaqueClosure` based on it.
"""
struct OpaqueClosureCreateInfo <: CallInfo

"""
Represents a resolved call of `Core.Compiler.return_type`.
`info.call` wraps the info corresponding to the call that `Core.Compiler.return_type` call
was supposed to analyze.
"""
struct ReturnTypeCallInfo <: CallInfo

"""
Represents the information of a potential (later) call to the finalizer on the given
object type.
"""
struct FinalizerInfo <: CallInfo

"""
Represents a resolved call of one of:
 - `modifyfield!(obj, name, op, x, [order])`
 - `modifyglobal!(mod, var, op, x, order)`
 - `memoryrefmodify!(memref, op, x, order, boundscheck)`
 - `Intrinsics.atomic_pointermodify(ptr, op, x, order)`

`info.info` wraps the call information of `op(getval(), x)`.
"""
struct ModifyOpInfo <: CallInfo

struct VirtualMethodMatchInfo <: CallInfo

"""
Represents access to a global through runtime reflection, rather than as a manifest
`GlobalRef` in the source code. Used for builtins (getglobal/setglobal/etc.) that
perform such accesses.
"""
struct GlobalAccessInfo <: CallInfo
=#


# from julia/Compiler/src/abstractinterpretation.jl
#=
struct RTEffects
    rt::Any
    exct::Any
    effects::Effects
    refinements # ::Union{Nothing,SlotRefinement,Vector{Any}}
    function RTEffects(rt, exct, effects::Effects, refinements=nothing)
        @nospecialize rt exct refinements
        return new(rt, exct, effects, refinements)
    end
end

CallMeta(rte::RTEffects, info::CallInfo) =
    CallMeta(rte.rt, rte.exct, rte.effects, info, rte.refinements)

struct InvokeCall
    types     # ::Type
    InvokeCall(@nospecialize(types)) = new(types)
end
=#


# from julia/Compiler/src/inferencestate.jl
#=
mutable struct InferenceState

mutable struct IRInterpretationState

const AbsIntState = Union{InferenceState,IRInterpretationState}


"""
    Future{T}

Assign-once delayed return value for a value of type `T`, similar to RefValue{T}.
Can be constructed in one of three ways:

1. With an immediate as `Future{T}(val)`
2. As an assign-once storage location with `Future{T}()`. Assigned (once) using `f[] = val`.
3. As a delayed computation with `Future{T}(callback, dep, interp, sv)` to have
   `sv` arrange to call the `callback` with the result of `dep` when it is ready.

Use `isready` to check if the value is ready, and `getindex` to get the value.
"""
struct Future{T}
    later::Union{Nothing,RefValue{T}}
    now::Union{Nothing,T}
    function Future{T}() where {T}
        later = RefValue{T}()
        @assert !isassigned(later) "Future{T}() is not allowed for inlinealloc T"
        new{T}(later, nothing)
    end
    Future{T}(x) where {T} = new{T}(nothing, x)
    Future(x::T) where {T} = new{T}(nothing, x)
end
=#

end # module test_corecompiler_abstract_interpretation
