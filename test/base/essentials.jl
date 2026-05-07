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

end # module test_base_essentials
