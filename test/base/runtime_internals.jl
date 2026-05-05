module test_base_runtime_internals

# see also corecompiler/tfuncs.jl

using Test

@test Base.datatype_fieldcount(Tuple)            == nothing
@test Base.datatype_fieldcount(Int)              == 0
@test Base.datatype_fieldcount(typeof(+))        == 0
@test Base.datatype_fieldcount(Tuple{Int})       == 1
@test Base.datatype_fieldcount(Vector{Int})      == 2
@test Base.datatype_fieldcount(NTuple{100, Int}) == 100

# from julia/base/runtime_internals.jl
isconcretetype
# isconcretetype(@nospecialize(t)) = (@_total_meta; isa(t, DataType) && (t.flags & 0x0002) == 0x0002)
isabstracttype
# function isabstracttype(@nospecialize(t))
#   @_total_meta
#   t = unwrap_unionall(t)
#   # TODO: what to do for `Union`?
#   return isa(t, DataType) && (t.name.flags & 0x1) == 0x1
Base.iskindtype # DataType, UnionAll, Union, Core.TypeofBottom
# iskindtype(@nospecialize t) = (t === DataType || t === UnionAll || t === Union || t === typeof(Bottom))
Base.isconcretedispatch  # isconcretetype ∘ !iskindtype
# isconcretedispatch(@nospecialize t) = isconcretetype(t) && !iskindtype(t)
Base.isdispatchtuple
# isdispatchtuple(@nospecialize(t)) = (@_total_meta; isa(t, DataType) && (t.flags & 0x0004) == 0x0004)
Base.is_datatype_layoutopaque
# function is_datatype_layoutopaque(dt::DataType)
#   datatype_nfields(dt) == 0 && !datatype_pointerfree(dt)
Base.issingletontype
# issingletontype(@nospecialize(t)) = (@_total_meta; isa(t, DataType) && isdefined(t, :instance) && datatype_layoutsize(t) == 0 && datatype_pointerfree(t))

@test isconcretetype(DataType)
@test isabstracttype(Number)
@test Base.iskindtype(Union)
@test Base.isconcretedispatch(Int)
@test Base.isdispatchtuple(Tuple{Int})
@test Base.issingletontype(Nothing)

struct S
end
@test Base.isconcretetype(S)
@test Base.issingletontype(S)

struct S2
    field
end
@test Base.isconcretetype(S2)
@test !(Base.issingletontype(S2))

T = Union{Int, String}
@test typeintersect(Int, T) === Int

@test Base.uniontypes(T) == [Int, String]
@test Base.unionlen(T) == 2
@test Union{Base.uniontypes(T)...} === T

end # module test_base_runtime_internals


using Jive
# @__FUNCTION__  julia commit bea90a2f503018115b30559b9d6838c05a86b9b4
@If VERSION >= v"1.13.0-DEV.878" module test_base_runtime_internals_function_macro

using Test

function g()
    f = @__FUNCTION__
    nameof(f)
end

@test g() === :g

λ() = eval(Expr(:thisfunction))
@test λ isa Function

end # module test_base_runtime_internals_function_macro
