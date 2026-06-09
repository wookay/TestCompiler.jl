module test_base_runtime_internals

# see also base/partition_kind.jl
#          corecompiler/tfuncs.jl

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

struct S1
end
@test Base.isconcretetype(S1)
@test Base.issingletontype(S1)

struct S2
    field
end
@test Base.isconcretetype(S2)
@test !(Base.issingletontype(S2))

UT = Union{Int, String}
@test typeintersect(Int, UT) === Int

@test Base.uniontypes(UT) == Any[Int, String]
@test Base.unionlen(UT) == 2
@test Union{Base.uniontypes(UT)...} === UT

@enum E a b
@test instances(E) === (a, b)

@test Base.to_tuple_type((Int,)) === Tuple{Int}

@test Base.signature_type(+, (Int,)) === Tuple{typeof(+), Int}

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


# julia commit f1477a9009
@If VERSION >= v"1.14.0-DEV.2173" module test_base_runtime_internals_DataTypeLayout

using Test

# from julia/base/runtime_internals.jl
# struct DataTypeLayout
#     size::UInt32
#     nfields::UInt32
#     npointers::UInt32
#     firstptr::Int32
#     alignment::UInt16
#     flags::UInt16
# end

dtl = Base.DataTypeLayout(Int64::DataType)
@test dtl.size      == 0x00000008
@test dtl.nfields   == 0x00000000
@test dtl.npointers == 0x00000000
@test dtl.firstptr  == -1
@test dtl.alignment == 0x008
@test dtl.flags     == 0x0080
@test dtl == Base.DataTypeLayout(dtl.size, dtl.nfields, dtl.npointers, dtl.firstptr, dtl.alignment, dtl.flags)
@test Base.datatype_layoutsize(dtl) == dtl.size % Int
@test Base.datatype_nfields(dtl) == dtl.nfields
@test Base.datatype_npointers(dtl) == dtl.npointers
@test Base.datatype_alignment(dtl) == Int(dtl.alignment)

@test Base.datatype_haspadding(dtl) === false
@test Base.datatype_isbitsegal(dtl) === true
@test Base.datatype_fielddesc_type(dtl) == (dtl.flags >> 1) & 3
@test Base.datatype_arrayelem(dtl) == (dtl.flags >> 3) & 3

dtl_str = Base.DataTypeLayout(String::DataType)
@test dtl_str.size == 0x00000000

end # module test_base_runtime_internals_DataTypeLayout


using Jive
@If VERSION >= v"1.12" module test_base_runtime_internals_binding

using Test

module K
f() = nothing
end

using .K: f

@test Base.binding_module(@__MODULE__, :f) === K
@test Base.binding_kind(K, :f)           == Base.PARTITION_KIND_CONST
@test Base.binding_kind(@__MODULE__, :f) == Base.PARTITION_KIND_EXPLICIT

gr::Core.GlobalRef = Core.GlobalRef(K, :f)
world::UInt = Base.get_world_counter()
bpart::Core.BindingPartition = Base.lookup_binding_partition(world, gr)
@test Base.binding_kind(bpart) == Base.PARTITION_KIND_CONST

b::Core.Binding = convert(Core.Binding, gr)
(; restriction, min_world, max_world) = b.partitions
@test restriction === f
@test world in min_world:max_world

end # module test_base_runtime_internals_binding
