using Jive
@If VERSION >= v"1.13.0-DEV.151" module test_compiler_jl_partition_kind

using Test
using TestCompiler # PartitionKind

function sprint_plain(x)::String
    sprint(io -> show(io, MIME"text/plain"(), x))
end

@test PartitionKind(0x9) == PartitionKind(Base.PARTITION_KIND_GUARD)
@test sprint_plain(PartitionKind(Base.PARTITION_KIND_GUARD)) ==
      """const PARTITION_KIND_GUARD = 0x9\n  Guard: The binding was looked at, but no global or import was resolved at\n  the time\n\n  ->restriction is NULL."""

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

# from julia/base/runtime_internals.jl
# function lookup_binding_partition(world::UInt, b::Core.Binding)
# function lookup_binding_partition(world::UInt, gr::Core.GlobalRef)
Base.lookup_binding_partition

end # module test_compiler_jl_partition_kind
