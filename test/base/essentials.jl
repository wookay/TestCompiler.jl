module test_base_essentials

using Test

Base.unwrap_unionall
# from julia/base/essentials.jl
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

end # module test_base_essentials
