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
