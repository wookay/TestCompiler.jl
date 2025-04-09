module test_compiler_reflection_REFLECTION_COMPILER

using Test

# from julia/Compiler/test/setup_Compiler.jl
if VERSION >= v"1.12.0-DEV.1571"
@test !isdefined(Main, :__custom_compiler_active)
@test Base.REFLECTION_COMPILER[] === nothing

@eval Main begin
    __custom_compiler_active = true
end
using Base: Compiler
Compiler.activate!(; codegen = true)

@test isdefined(Main, :__custom_compiler_active)
@test Base.REFLECTION_COMPILER[] == Compiler
end

end # module test_compiler_reflection_REFLECTION_COMPILER
