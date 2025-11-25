using Jive
@If VERSION >= v"1.14.0-DEV.60" module test_corecompiler_cicache

# julia/Compiler/src/cicache.jl
# ci::CodeInstance
# cache::InternalCodeCache

using Test
using Core: Compiler as CC
using .CC: WorldRange, OverlayCodeCache, InternalCodeCache, InferenceResult

worlds = (; min_world, max_world) = WorldRange(1, 2)
@test min_world == worlds.min_world == 1
@test max_world == worlds.max_world == 2

interp = CC.NativeInterpreter()
world = CC.get_inference_world(interp)

wvc = CC.code_cache(interp)
@test wvc isa OverlayCodeCache{InternalCodeCache}
@test wvc.globalcache.worlds.max_world == world
@test wvc.localcache == InferenceResult[]

end # module test_corecompiler_cicache
