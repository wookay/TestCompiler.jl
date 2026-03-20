module test_base_worlds

using Test

# from julia/test/worlds.jl
@test_throws UndefVarError x

f() = 1
wc1::UInt64 = Base.get_world_counter()

# WARNING: Method definition f() in module test_base_worlds at worlds.jl:8 overwritten at worlds.jl:12
f() = 2
wc2::UInt64 = Base.get_world_counter()

@test Base.invoke_in_world(wc1, f) == 1
@test Base.invoke_in_world(wc2, f) == 2


# from julia/test/worlds.jl
rettype_with_side_effect() = eval(:(rettype_side_effect = "blah"; Cint))
if VERSION >= v"1.14.0-DEV.1921" # julia commit d79443c60e
    @test rettype_side_effect == "blah"
    ccall(:strlen, rettype_with_side_effect(), (Cstring,), "xx")
end

end # module test_base_worlds
