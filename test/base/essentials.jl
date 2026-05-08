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
using .CC: Const
typ = Tuple{Int64, UInt64}
if VERSION >= v"1.12"
PT = PartialStruct(CC.fallback_lattice, typ, Any[Const(10), UInt64])
@test isa(PT, PartialStruct)
@test PT.typ === typ
# julia commit 199855161e
# from julia/Compiler/src/abstractinterpretation.jl
# function precise_container_type
widet = Base.unwrap_unionall(PT.typ)
@test isa(widet, DataType)
@test widet === typ
end # if

end # module test_base_essentials
