module test_base_essentials

# see also corecompiler/abstract_interpretation.jl
#          base/core.jl

using Test

# from julia/base/essentials.jl

Base.unwrap_unionall
# function unwrap_unionall(@nospecialize(a))
#     @_foldable_meta
#     while isa(a,UnionAll)
#         a = a.body
#     end
#     return a
# end

@test Vector isa UnionAll
@test Base.unwrap_unionall(Vector) === Vector.body

abstract type AbstractCat{T} end
@test AbstractCat isa UnionAll
@test Base.unwrap_unionall(AbstractCat) === AbstractCat.body

const ACat = AbstractCat{T} where T
@test ACat isa UnionAll
@test Base.unwrap_unionall(ACat) === ACat.body

# from julia/Compiler/test/inference.jl
using Core: PartialStruct, Compiler as CC
if VERSION >= v"1.12"
using .CC: Const, Future, AbstractIterationResult
typ = Tuple{Int64, UInt64}
PT = PartialStruct(CC.fallback_lattice, typ, Any[Const(10), UInt64])
@test isa(PT, PartialStruct)
@test PT.typ === typ
# julia commit 199855161e
# from julia/Compiler/src/abstractinterpretation.jl
# `typ` is the inferred type for expression `arg`.
# if the expression constructs a container (e.g. `svec(x,y,z)`),
# refine its type to an array of element types.
# Union of Tuples of the same length is converted to Tuple of Unions.
# returns an array of types
# function precise_container_type(interp::AbstractInterpreter, @nospecialize(itft), @nospecialize(typ),
#                                 vtypes::Union{VarTable,Nothing}, sv::AbsIntState)
widet = Base.unwrap_unionall(PT.typ)
@test isa(widet, DataType)
@test widet === typ
@test widet.name === Tuple.name
future = Future(AbstractIterationResult(PT.fields, nothing))
@test future isa Future
end # if


Base.isvarargtype
# function isvarargtype(@nospecialize(t))
#     return isa(t, Core.TypeofVararg)
# end
@test Base.isvarargtype(Vararg{Any})
f(args...) = nothing
m = only(methods(f))
@test m.sig.parameters[2] === Vararg{Any}
@test Base.isvarargtype(m.sig.parameters[2])


Base.unwrapva
# function unwrapva(@nospecialize(t))
#     isa(t, Core.TypeofVararg) || return t
#     return isdefined(t, :T) ? t.T : Any
# end
@test Base.unwrapva(Vararg{Any}) === Any
@test Base.unwrapva(Vararg{Tuple{Int, String}}) === Tuple{Int64, String}


#=
  struct Core.TypeofVararg

  Fields
  ≡≡≡≡≡≡

  T :: Any
  N :: Any
=#


@test Base._is_internal(Base) === true
@test Base._is_internal(Core.Compiler) === true
@test Base._is_internal(Core) === false

# supposed to be used for bootstrapping
# macro _total_meta()
# macro _foldable_meta()
# macro _terminates_locally_meta()
# macro _terminates_globally_meta()
# macro _terminates_globally_notaskstate_meta()
# macro _terminates_globally_noub_meta()
# macro _effect_free_terminates_locally_meta()
# macro _nothrow_noub_meta()
# macro _nothrow_meta()
# macro _noub_meta()
# macro _notaskstate_meta()
# macro _noub_if_noinbounds_meta()

end # module test_base_essentials


module test_base_essentials_convert

using Test

@test convert(Bool, 1)
@test Base.cconvert(Bool, 1)
@test_throws InexactError convert(Bool, 2)

@test convert(Int, true) == 1

end # module test_base_essentials_convert


module test_base_essentials_compilerbarrier

using Test

Core.compilerbarrier
Base.inferencebarrier # Core.compilerbarrier(:type, x)
if VERSION >= v"1.14.0-DEV.1953" # julia commit 8ffcedf6cd
Base.blackbox         # Core.compilerbarrier(:blackbox, x)
end
Base.donotdelete

# from help?> Core.compilerbarrier

T11 = (only ∘ Base.return_types)((Int,)) do a
    x = Core.compilerbarrier(:type, a) # `x` won't be inferred as `x::Int`
    return x
end
T12 = (only ∘ Base.return_types)((Int,)) do a
    x = Base.inferencebarrier(a)
    return x
end
@test T11 === T12 === Any

f(x::Int) = x
T15 = (only ∘ Base.return_types)(f)
T16 = (only ∘ Base.return_types)((Int,)) do x
    return x
end
@test T15 === T16 === Int

T21 = (only ∘ Base.return_types)() do
    x = Core.compilerbarrier(:const, 42)
    if x == 42 # no constant information here, so inference also accounts for the else branch
        return x # but `x` is still inferred as `x::Int` at least here
    else
        return nothing
    end
end
@test T21 === Union{Nothing, Int}

T25 = (only ∘ Base.return_types)() do
    x = 42
    if x == 42
        return x
    else
        return nothing
    end
end
@test T25 === Int

T31 = (only ∘ Base.return_types)((Union{Int,Nothing},)) do a
    if Core.compilerbarrier(:conditional, isa(a, Int))
        # the conditional information `a::Int` isn't available here (leading to less accurate return type inference)
        return a
    else
        return nothing
    end
end
@test T31 === Union{Nothing, Int}

function g1()
    Core.compilerbarrier(:blackbox, 42)
end
function g2()
    Base.blackbox(42)
end
function g5()
    42
end
if VERSION >= v"1.14.0-DEV.1953" # julia commit 8ffcedf6cd
    @test g1() == g2() == g5() == 42
end
#=
julia> Base.code_typed(g1)[1]
CodeInfo(
1 ─ %1 =   builtin (Core.compilerbarrier)(:blackbox, 42)::Int64
└──      return %1
) => Int64

julia> Base.code_typed(g2)[1]
CodeInfo(
1 ─ %1 =   builtin Base.compilerbarrier(:blackbox, 42)::Int64
└──      return %1
) => Int64

julia> Base.code_typed(g5)[1]
CodeInfo(
1 ─     return 42
) => Int64
=#


@test Base.donotdelete === Core.donotdelete === Core.Compiler.donotdelete

end # module test_base_essentials_compilerbarrier
