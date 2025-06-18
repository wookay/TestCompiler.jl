module test_corecompiler_worlds

using Test

# from julia/test/worlds.jl
@test_throws UndefVarError x

f() = 1
wc1::UInt64 = Base.get_world_counter()

# WARNING: Method definition f() in module test_compiler_worlds at worlds.jl:8 overwritten at worlds.jl:12
f() = 2
wc2::UInt64 = Base.get_world_counter()

@test Base.invoke_in_world(wc1, f) == 1
@test Base.invoke_in_world(wc2, f) == 2

end # module test_corecompiler_worlds
