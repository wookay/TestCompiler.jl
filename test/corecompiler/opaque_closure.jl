module test_corecompiler_opaque_closure

using Test
using Base.Experimental: @opaque

oc = @opaque(x->2x)
@test oc isa Core.OpaqueClosure
@test oc.captures == ()
@test oc.world isa Int64
@test oc.source isa Core.Method
@test oc.invoke isa Ptr{Nothing}
@test oc.specptr isa Ptr{Nothing}

# from julia/base/opaque_closure.jl
#=
"""
    @opaque ([type, ]args...) -> body

Marks a given closure as "opaque". Opaque closures capture the
world age of their creation (as opposed to their invocation).
This allows for more aggressive optimization of the capture
list, but trades off against the ability to inline opaque
closures at the call site, if their creation is not statically
visible.

An argument tuple type (`type`) may optionally be specified, to
specify allowed argument types in a more flexible way. In particular,
the argument type may be fixed length even if the function is variadic.

!!! warning
    This interface is experimental and subject to change or removal without notice.
"""
macro opaque(ex)
=#

end # module test_corecompiler_opaque_closure
