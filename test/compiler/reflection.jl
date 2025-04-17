module test_compiler_reflection_REFLECTION_COMPILER

using Test

# from julia/Compiler/test/setup_Compiler.jl
if VERSION >= v"1.12.0-DEV.1571"
@test !isdefined(Main, :__custom_compiler_active)
@test Base.REFLECTION_COMPILER[] === nothing

@eval Main begin
    __custom_compiler_active = true
end

# julia/Compiler/src/bootstrap.jl
# WARNING: Method definition typeinf(Nothing, Core.MethodInstance, UInt8) in module Compiler at ../usr/share/julia/Compiler/src/bootstrap.jl:12 overwritten on the same line (check for duplicate calls to `include`).
using Jive
Jive.delete(Core.OptimizedGenerics.CompilerPlugins.typeinf, Tuple{Nothing, Core.MethodInstance, UInt8})

using Base: Compiler
Compiler.activate!(; codegen = true)

@test isdefined(Main, :__custom_compiler_active)
@test Base.REFLECTION_COMPILER[] == Compiler
end

end # module test_compiler_reflection_REFLECTION_COMPILER
