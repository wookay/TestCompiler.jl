using Jive
@If VERSION >= v"1.13.0-DEV.151" module test_compiler_jl_partition_kind

using Test
using TestCompiler

# from julia/test/rebinding.jl

@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_GUARD

struct Foo
    x::Int
end

@test Base.binding_kind(@__MODULE__, :Foo) == Base.PARTITION_KIND_CONST

# from julia/base/runtime_internals.jl
# function lookup_binding_partition(world::UInt, b::Core.Binding)
# function lookup_binding_partition(world::UInt, gr::Core.GlobalRef)
Base.lookup_binding_partition

end # module test_compiler_jl_partition_kind
