module test_compiler_cicache

# julia/Compiler/src/cicache.jl
# ci::CodeInstance
# cache::InternalCodeCache

using Test
using Core: Compiler as CC
using .CC: WorldRange, WorldView

worlds = (; min_world, max_world) = WorldRange(1, 2)
@test min_world == worlds.min_world == 1
@test max_world == worlds.max_world == 2

interp = CC.NativeInterpreter()
world = CC.get_inference_world(interp)

wvc = CC.code_cache(interp)
@test wvc isa WorldView{CC.InternalCodeCache}
@test wvc.worlds.max_world == world

end # module test_compiler_cicache
