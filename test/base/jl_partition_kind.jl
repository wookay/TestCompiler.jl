using Jive
@If VERSION >= v"1.13.0-DEV.151" module test_base_jl_partition_kind

using Test

# from julia/test/rebinding.jl

@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_GUARD

struct Foo
    x::Int
end
@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_CONST

Base.delete_binding(@__MODULE__, :Foo)
@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_GUARD

const Foo = 1
@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_CONST

Base.delete_binding(@__MODULE__, :Foo)
@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_GUARD

# from julia/base/runtime_internals.jl
# function lookup_binding_partition(world::UInt, b::Core.Binding)
# function lookup_binding_partition(world::UInt, gr::Core.GlobalRef)
Base.lookup_binding_partition

world1 = Base.get_world_counter()
gr1 = GlobalRef(@__MODULE__, :Foo)
partition1 = Base.lookup_binding_partition(world1, gr1)
@test Base.binding_kind(partition1) == partition1.kind == Base.PARTITION_KIND_GUARD
@test partition1 isa Core.BindingPartition

struct Foo
    x2::Int
end
world2 = Base.get_world_counter()
gr2 = GlobalRef(@__MODULE__, :Foo)
partition2 = Base.lookup_binding_partition(world2, gr2)
@test partition2.kind == Base.PARTITION_KIND_CONST

const const_var = 42
@test Base.binding_kind(@__MODULE__, :const_var) == Base.PARTITION_KIND_CONST

global global_var
@test Base.binding_kind(@__MODULE__, :global_var) == Base.PARTITION_KIND_DECLARED
global_var = 1
@test Base.binding_kind(@__MODULE__, :global_var) == Base.PARTITION_KIND_GLOBAL

@test Base.binding_kind(Base, :pi)        == Base.PARTITION_KIND_EXPLICIT
@test Base.binding_kind(@__MODULE__, :pi) == Base.PARTITION_KIND_IMPLICIT_CONST

module M
imported_var = 42
end
@test Base.binding_kind(M, :imported_var) == Base.PARTITION_KIND_GLOBAL

@test Base.binding_kind(@__MODULE__, :imported_var) == Base.PARTITION_KIND_GUARD
import .M: imported_var
@test Base.binding_kind(@__MODULE__, :imported_var) == Base.PARTITION_KIND_IMPORTED

end # module test_base_jl_partition_kind
