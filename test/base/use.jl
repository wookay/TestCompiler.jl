module test_base_use

module A
using Test
using Jive
build_id = Base.module_build_id(Jive)
@test build_id isa UInt128
function f()
topmod = Base.moduleroot(@__MODULE__)
old_uuid = ccall(:jl_module_uuid, NTuple{2, UInt64}, (Any,), Jive)
@test old_uuid == (0xba5e3d4b8524549f, 0xbc71e76ad9e9deed)
end # function f

using UUIDs
m = Base.maybe_loaded_precompile(Base.PkgId(UUID(0xba5e3d4b8524549f_bc71e76ad9e9deed), "Jive"), build_id)
@test Jive == m

end # module A

using .A: f
f()

end # module test_base_use
