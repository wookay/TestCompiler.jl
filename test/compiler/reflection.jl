module test_compiler_reflection_REFLECTION_COMPILER

using Test

# from julia/Compiler/test/setup_Compiler.jl
if VERSION >= v"1.12.0-DEV.1571"
@test Base.REFLECTION_COMPILER[] === nothing
end
@test !isdefined(Main, :__custom_compiler_active)

end # module test_compiler_reflection_REFLECTION_COMPILER
