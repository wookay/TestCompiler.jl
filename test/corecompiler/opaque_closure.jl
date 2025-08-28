module test_corecompiler_opaque_closure

using Test
using Base.Experimental: @opaque

oc = @opaque(x->2x)
@test oc isa Core.OpaqueClosure

end # module test_corecompiler_opaque_closure
